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

	def minimum_left_node(root)
		current_node = root
		current_node = current_node.left until current_node.left.nil?
		current_node
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

	def pretty_print(node = @root, prefix = '', is_left = true)
		pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
		puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
		pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
	end	
end

new_tree = Tree.new(Array.new(15){rand(1..100)}) 
p new_tree.pretty_print