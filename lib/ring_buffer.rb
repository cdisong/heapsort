require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @capacity = 8 
    @store = StaticArray.new(@capacity) 
    @length = 0 
    @start_idx = 0 
  end

  # O(1)
  def [](index)
    check_index(index)
    idx = (index + @start_idx) % @capacity 
    @store[idx]
  end

  # O(1)
  def []=(index, val)
    check_index(index)
    idx = (index + @start_idx) % @capacity 
    @length += 1 if @store[idx] == nil 
    @store[idx] = val 
  end

  # O(1)
  def pop
    check_index
    idx = (@start_idx + @length - 1) % @capacity 
    take = @store[idx] 
    @store[idx] = nil 
    @length -= 1 
    take 
  end

  # O(1) ammortized
  def push(val)
    resize! 
    idx = (@start_idx + @length) % @capacity
    @store[idx] = val 
    @length += 1 
  end

  # O(1)
  def shift
    check_index 
    shift = @store[@start_idx]
    @store[@start_idx] = nil 
    @length -= 1 
    @start_idx = (@start_idx + 1) % capacity 
    shift
  end

  # O(1) ammortized
  def unshift(val)
    resize!
    if @store[@start_idx] == nil 
      @store[@start_idx] = val 
      @length += 1 
    else 
      idx = (@start_idx - 1) % @capacity 
      @store[idx] = val 
      @length += 1 
      @start_idx = idx 
    end
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index = 0)
    if @length <= 0 || index >= @length 
      raise 'index out of bounds'
    end 
  end

  def resize!
    if @length >= @capacity 
      @capacity *= 2 
      new_s = StaticArray.new(@capacity) 
      (0...@length).each do |idx|
        if idx < @start_idx 
          new_s[idx] = @store[idx] 
        else 
          new_s[idx + @length] = @store[idx] 
        end 
      end 
      @store = new_s 
      @start_idx += @length
    end 
  end
end
