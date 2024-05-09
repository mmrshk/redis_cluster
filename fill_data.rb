require 'redis'

# Connect to Redis server
redis = Redis.new(host: 'redis-master', port: 6379)
# redis = Redis.new(url: 'redis://your_password@redis-master:6379/0')

# 1.3 MB * 1,048,576 bytes/MB = 1,365,615.8 bytes (approximately)
max_memory = 1365615

begin
  index = 1
  while true
    key = "key#{index}"
    value = "value#{index}"
    # redis.set(key, value, ex: 10)
    redis.set(key, value)

    # Calculate memory used by the Redis instance
    info = redis.info('memory')
    memory_used = info['used_memory'].to_i

    # Check if memory limit is reached
    puts "#{key}-#{value}-#{index}-#{memory_used}"
    break if memory_used >= max_memory

    index += 1
  end

  puts "Memory limit reached. Total keys set: #{index}"
rescue Redis::CommandError => e
  puts "Error: #{e.message}"
end
