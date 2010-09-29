module TimedCache
  def self.fetch(cache_key, options={})
    data = Rails.cache.read(cache_key)
    expires_in = options[:expires_in] || 0.seconds
    if !data || data[:inserted_at] <  expires_in.ago.utc
      value = yield
      Rails.cache.write(cache_key, {
        :inserted_at => Time.now.utc,
        :data => value
      })
      return value
    else
      return data[:data]
    end
  end
end

