require 'net/http'
require 'json'

Puppet::Type.type(:katello_node).provide(:net_http) do

  def exists?
    node_exists?
  end

  def create
    create_node
  end

  private

  def node_exists?
    response = http_request(:get, "/api/nodes/by_uuid/#{uuid}")
    response.code == "200"
  end

  def create_node
    capabilities = []
    capabilities << { :type => "content" } if resource[:content]
    data = { :node =>
             { :system_uuid => uuid,
               :capabilities => capabilities } }
    response = http_request(:post, "/api/nodes", data)
    unless response.code == "200"
      raise "Failed to register the node: #{response.body}"
    end
  end

  def http_request(method, path, data = {})
    uri = URI.parse("#{resource[:base_url]}/#{path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    http.cert = OpenSSL::X509::Certificate.new(cert)
    http.key = OpenSSL::PKey::RSA.new(key)

    request_class = case method
    when :get
      Net::HTTP::Get
    when :post
      Net::HTTP::Post
    when :delete
      Net::HTTP::Delete
    when :put
      Net::HTTP::Put
    else
      raise "Unknown http method #{method}"
    end
    request = request_class.new(uri.request_uri)
    if data
      request.content_type = 'application/json'
      request.body = JSON.dump(data)
    end
    return http.request(request)
  end

  def cert
    File.read('/etc/pki/consumer/cert.pem')
  end

  def key
    File.read('/etc/pki/consumer/key.pem')
  end

  def uuid
    return @uuid if @uuid
    rhsm_idenetity_output = `subscription-manager identity`
    if @uuid = rhsm_idenetity_output[/(\w+-){4}\w+/]
      return @uuid
    else
      raise "Could not extract the uuid of the machine"
    end
  end

end
