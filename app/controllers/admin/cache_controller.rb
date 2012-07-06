class Admin::CacheController < AdminController
    def index
        @info = Cacher.info
        @urls = Cacher.keys
    end

    def destroy
        slug = CGI::unescape(params[:id])
        Cacher.redis.del(slug)
        if Cacher.redis.get(slug).nil?
            flash[:success] = 'URL deleted.'
        else
            flash[:error] = 'Unable to delete URL.'
        end
        redirect_to admin_cache_index_path
    end

    def rebuild
        changes_orig = Cacher.info['changes_since_last_save']
        Cacher.reset!
        changes = Cacher.info['changes_since_last_save']
        if changes == changes_orig
            flash[:error] = "There was an error rebuilding the cache"
        else
            flash[:success] = "Cache rebuilt successfully"
        end
        redirect_to admin_cache_index_path
    end
end