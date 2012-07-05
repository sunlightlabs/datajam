module RebuildCacheJob
    def self.perform
        Cacher.reset!
    end
end