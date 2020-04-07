require "fluent/plugin/filter_imds/version"
require 'fluent/plugin/filter'
require 'socket'
require 'net/http'
require 'uri'

module Fluent
  class IMDSFilter < Filter
    Fluent::Plugin.register_filter('imds', self)

    # config_param works like other plugins
    config_param :testparam, :string, :default => "Nothing"


    def configure(conf)
      super
      # do the usual configuration here

    end

    def start
      super
      # This is the first method to be called when it starts running
      # Use it to allocate resources, etc.
    end

    def shutdown
      super
      # This method is called when Fluentd is shutting down.
      # Use it to free up resources, etc.
    end

    def stripKVPValue(unstrippedString)
        reachedStartOfContainerId = false
        containerID = ""
        unstrippedString.each_char {|c|
            if c == "\u0000"
                if reachedStartOfContainerId
                    return containerID
                end
            else
                if !reachedStartOfContainerId
                    reachedStartOfContainerId = true
                end
                containerID += c
            end
        }
        containerID
    end

    def filter(tag, time, record)

      uri = URI.parse("http://169.254.169.254/metadata/instance?api-version=2019-11-01")
      request = Net::HTTP::Get.new(uri)
      request["Metadata"] = "true"

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
      end

      data = JSON.parse(response.body)

      record["subscriptionId"] = data["compute"]["subscriptionId"]
      record["region"] = data["compute"]["location"]
      record["resourceGroup"] = data["compute"]["resourceGroupName"]
      record["vmName"] = data["compute"]["name"]
      record["vmSize"] = data["compute"]["vmSize"]
      record["vmId"] = data["compute"]["vmId"]
      record["placementGroup"] = data["compute"]["placementGroupId"]
      unstrippedDistro = `lsb_release -si`
      record["distro"] = unstrippedDistro.strip
      unstrippedVersion = `lsb_release -sr`
      record["distroVersion"] = unstrippedVersion.strip
      unstrippedKernel = `uname -r`
      record["kernelVersion"] = unstrippedKernel.strip
      unstrippedContainerId = `cat /var/lib/hyperv/.kvp_pool_3 | sed -e 's/^.*VirtualMachineName//'      `
      strippedContainerId = stripKVPValue(unstrippedContainerId)
      record["containerID"] = strippedContainerId

      record
    end
  end
end

