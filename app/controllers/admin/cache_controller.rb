class Admin::CacheController < AdminController
    def index
        @urls, @timestamp = Cacher.get_info
    end

    def rebuild
        timestamp = Cacher.timestamp
        Cacher.reset!
        @timestamp = Cacher.timestamp
        if timestamp == @timestamp
            flash[:error] = "There was an error rebuilding the cache"
        else
            flash[:success] = "Cache rebuilt successfully"
        end
        redirect_to admin_cache_index_path
    end
end