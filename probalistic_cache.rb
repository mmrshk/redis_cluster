require 'redis'

class ProbabilisticCacheRedisClient
  def initialize(redis_url)
    @redis = Redis.new(url: redis_url)
    @probability = 0.1
  end

  def set(key, value)
    @redis.set(key, value)
  end

  def get(key, ttl = 60)
    value = @redis.get(key)

    if value.nil?
      value = yield
      set(key, value)
    elsif @redis.ttl(key) < ttl / 2
      Thread.new { revalidate_cache(key, ttl) }
    end

    value
  end

  def delete(key)
    @redis.del(key)
  end

  def probabilistic_clear
    @redis.keys.each do |key|
      @redis.del(key) if rand < @probability
    end
  end

  private

  def revalidate_cache(key, ttl)
    new_value = yield

    if @redis.exists(key)
      @redis.setex(key, ttl, new_value)
    end
  end
end
