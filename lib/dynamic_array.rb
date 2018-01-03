require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @length = 0 
    @capacity = 8 
    @store = StaticArray.new(@capacity)
  end

  # O(1)
  def [](index)
    self.check_index(index)
    @store[index]
  end

  # O(1)
  def []=(index, value)
    self.check_index(index)
    @store[index] = value 
    @store 
  end

  # O(1)
  def pop
    self.remove
    @length -= 1 
    value = @store[@length]
    @store[@length] = nil 
    value 
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    self.resize! if @length == @capacity 
    @store[@length] = val
    @length += 1 
    @store 
  end

  # O(n): has to shift over all the elements.
  def shift
    self.remove
    tmp = StaticArray.new(@capacity)
    (1..@length).each do |i|
      tmp[i-1] = @store[i] 
    end 
    val = @store[0] 
    @store = tmp 
    @length -= 1 
    val 
  end

  # O(n): has to shift over all the elements.
  def unshift(val) 
    self.resize! if @length == @capacity 
    tmp = StaticArray.new(@capacity) 
    tmp[0] = val 
    (0...@length).each do |i|
      tmp[i+1] = @store[i]
    end 
    @store = tmp 
    @length += 1 
    @store
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    raise 'index out of bounds' if (index + 1) > @length 
  end

  def remove 
    raise 'index out of bounds' if @length == 0 
  end 

  # O(n): has to copy over all the elements to the new store.
  def resize!
    tmp = StaticArray.new(@capacity * 2)
    (0..@capacity).each do |i| 
      tmp[i] = @store[i] 
    end 
    @store = tmp 
    @capacity = @capacity *  2 
  end
end
