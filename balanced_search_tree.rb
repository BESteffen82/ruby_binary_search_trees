require 'pry-byebug'

class Node
	include Comparable

	attr_accessor :data, :left, :right

	def initialize(data)
		@data = data
		@left = nil
		@right = nil
	end
end

class Tree

	attr_accessor :root

	def initialize(arr)
		@arr = arr.uniq.sort
		@root = build_tree(@arr, 0, @arr.length - 1)
	end

	def build_tree(arr, start, last)
		return nil if start > last

		mid = (start + last)/ 2
		root = Node.new(arr[mid])
		root.left = build_tree(arr, start, mid - 1)
		root.right = build_tree(arr, mid + 1, last)
		root
	end

	def insert(value, root = @root)		
		return if value == root.data

		if value < root.data
			root.left.nil? ? root.left = Node.new(value) : insert(value, root.left)
		elsif value > root.data
			root.right.nil? ? root.right = Node.new(value) : insert(value, root.right)
		end
		root			
	end

	def delete(value, root = @root)
		return root if root.nil?

		if value < root.data
			root.left = delete(value, root.left)
			return root
		elsif value > root.data
			root.right = delete(value, root.right)
			return root
		else
			if root.left.nil?
				temp = root.right
				root = nil
				return temp
			elsif root.right.nil?
				root = nil
				temp = root.left
				return temp
			end 

			temp = minimum_left_node(root.right)
			root.data = temp.data
			root.right = delete(temp.data, root.right)
		end
		root
	end

	def find(value, root = @root)
		return root if root.nil? || root == value

		if value > root.data
			return find(value, root.right)
		else value < root.data
			return find(value, root.left)
		end
		root		
	end

	def level_order(root = @root, values = [])
		return nil if root.nil?

		queue = []
		queue.push(root)
		until queue.empty?
			current_root = queue.shift
			queue.push(current_root.left) unless current_root.left.nil?
			queue.push(current_root.right) unless current_root.right.nil?
			values.push(current_root.data)
		end
		values
	end

	def inorder(root = @root, values = [])
		return nil if root.nil?

		inorder(root.left, values) unless root.left.nil?
		values.push(root.data)
		inorder(root.right, values) unless root.right.nil?
		values
	end

	def preorder(root = @root, values = [])
		return nil if root.nil?

		values.push(root.data)
		preorder(root.left, values) unless root.left.nil?
		preorder(root.right, values) unless root.right.nil?
		values
	end

	def postorder(root = @root, values = [])
		return nil if root.nil?

		postorder(root.left, values) unless root.left.nil?
		postorder(root.right, values) unless root.right.nil?
		values.push(root.data)
		values
	end

	def height(value, root = @root)
		node = find(value)		
		node_height(value)
	end

	def depth(value)
		node = find(value)
		node_height(@root) - node_height(node)
	end

	def balanced?
		balanced = false
		diff = (node_height(@root.left) - node_height(@root.right)).abs
		if diff <= 1
			return true
		else diff > 1
			return false
		end
	end

	def rebalance
		rebalance_array = inorder
		print rebalance_array
		puts
		@root = build_tree(rebalance_array, 0, rebalance_array.length - 1)
	end

	def node_height(root)
		return -1 unless root

		[node_height(root.left), node_height(root.right)].max + 1
	end

	def minimum_left_node(root)
		current_node = root
		current_node = current_node.left until current_node.left.nil?
		current_node
	end

	def pretty_print(node = @root, prefix = '', is_left = true)
		pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
		puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
		pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
	end	
end

#test script
new_tree = Tree.new(Array.new(15){rand(1..100)}) 
print new_tree.pretty_print
print new_tree.balanced?
puts
print new_tree.level_order
puts
print new_tree.inorder
puts
print new_tree.preorder
puts
print new_tree.postorder
puts
10.times {new_tree.insert(rand(100..500))}
print new_tree.balanced?
puts
new_tree.rebalance
print new_tree.pretty_print
print new_tree.balanced?
puts
print new_tree.level_order
puts
print new_tree.inorder
puts
print new_tree.preorder
puts
print new_tree.postorder
