module Vault
  def self.boot
    @cipher = Gibberish::AES.new(ConfigStore.options['crypt_secret'])
  end

  def self.decrypt(data)
    @cipher.decrypt(data)
  end
end