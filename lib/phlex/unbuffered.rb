# frozen_string_literal: true

class Phlex::Unbuffered < BasicObject
	def initialize(object)
		@object = object
	end

	def inspect
		"Unbuffered(#{@object.class.name})[object: #{@object.inspect}]"
	end

	# Borrow some important methods from Object
	define_method :__class__,
		::Object.instance_method(:class)

	define_method :__public_send__,
		::Object.instance_method(:public_send)

	def respond_to_missing?(*args, &block)
		@object.respond_to?(*args, &block)
	end
	ruby2_keywords :respond_to_missing? if respond_to?(:ruby2_keywords, true)

	def method_missing(name, *args, &block)
		if @object.respond_to?(name)
			__class__.define_method(name) do |*a, &b|
				if a.any?
					@object.capture { @object.public_send(name, *a, &b) }
				else
					@object.capture { @object.public_send(name, &b) }
				end
			end

			# Now we've defined this missing method, we can call it.
			__public_send__(name, *args, &block)
		else
			super
		end
	end

	# Forward some methods to the original underlying method
	def call(*args, &block)
		@object.call(*args, &block)
	end
	ruby2_keywords :call if respond_to?(:ruby2_keywords, true)

	def send(*args, &block)
		@object.send(*args, &block)
	end
	ruby2_keywords :send if respond_to?(:ruby2_keywords, true)

	def public_send(*args, &block)
		@object.public_send(*args, &block)
	end
	ruby2_keywords :public_send if respond_to?(:ruby2_keywords, true)
end
