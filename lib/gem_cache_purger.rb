class GemCachePurger
  def self.call(gem_name)
    # We need to purge from Fastly and from Memcached
    ["info/#{gem_name}", "names"].each do |path|
      Rails.cache.delete(path)
      FastlyPurgeJob.perform_later(path:, soft: true)
    end

    Rails.cache.delete("deps/v1/#{gem_name}")
    FastlyPurgeJob.perform_later(path: "versions", soft: true)
    FastlyPurgeJob.perform_later(path: "gem/#{gem_name}", soft: true)
  end
end
