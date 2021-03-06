# need install signer https://github.com/ebeigarts/signer 
# run gem install signer
require "signer"

signer = Signer.new(File.read("message.xml"))
signer.cert = OpenSSL::X509::Certificate.new(File.read("rarsacerttest_7.pem"))
signer.private_key = OpenSSL::PKey::RSA.new(File.read("private.key"), "password")

signer.security_node = signer.document.root

signer.document.xpath("//u:Timestamp", { "u" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" }).each do |node|
  signer.digest!(node)
end

signer.document.xpath("//a:To", { "a" => "http://www.w3.org/2005/08/addressing" }).each do |node|
  signer.digest!(node)
end

signer.sign!(:security_token => true)

# File.open('message.xml', 'w'){ |file| file.write signer.to_xml }

puts signer.to_xml
