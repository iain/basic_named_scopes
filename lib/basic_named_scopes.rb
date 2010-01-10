# Basic named scopes for ActiveRecord. Propagates the parameters of the
# find-method as named scopes, for easy reusability and prettier code.
#
# Instead of writing:
# 
#   Post.all(:conditions => { :published => true }, :select => :title, :include => :author)
#
# You can now write:
#
#   Post.conditions(:published => true).select(:title).with(:author)
#
# All named scopes are called the same, except for +include+, which is now
# called +with+, because +include+ is a reserved method.
#
# Also, the scope +conditions+ is aliased as +where+, just as in ActiveRecord 3.
#
# Reuse them by making class methods:
#
#   class Post < ActiveRecord::Base
# 
#     def self.published
#       conditions(:published => true)
#     end
#
#     def self.visible
#       conditions(:visible => true)
#     end
#
#     def self.index
#       published.visible
#     end
#
#   end
#
# Also, the +all+-method is a named scope now, so you can chain after callling
# all, for greater flexibility.
#
#   Post.all.published
#
# Arrays can be used as multple parameters too, sparing you some brackets.
#
#   Post.with(:author, :comments).conditions("name LIKE ?", query)
#
# The +read_only+ and +lock+ scopes default to true, but can be adjusted.
#
#   Post.readonly         # => same as Post.all(:readonly => true)
#   Post.readonly(false)  # => same as Post.all(:readonly => false)
#
module BasicNamedScopes

  # These are the normal parameters that will be turned into named scopes.
  FIND_PARAMETERS       = [:conditions, :order, :group, :having, :limit, :offset, :joins, :select, :from]

  # These are aliased parameters. The keys are scope names, the values are the option they represent.
  FIND_ALIASES          = { :where => :conditions, :with => :include }

  # These are the parameters that want a boolean.
  FIND_BOOLEAN_SWITCHES = [:readonly, :lock]

  class << self

    # When you extend an ActiveRecord model (or Base for that matter) it will
    # add the named scopes. This will automatically be done when the gem is
    # loaded.
    def extended(model)
      apply_basic_named_scopes(model)
    end

    def apply_basic_named_scopes(model)
      FIND_PARAMETERS.each do |parameter|
        model.named_scope(parameter, expand_into_array(parameter))
      end
      FIND_ALIASES.each do |name, parameter|
        model.named_scope(name, expand_into_array(parameter))
      end
      FIND_BOOLEAN_SWITCHES.each do |parameter|
        model.named_scope(parameter, default_to_true(parameter))
      end
      model.named_scope(:all, default_to_empty_hash)
    end

    private

    # The lambda for normal parameters. Will return an array when passed
    # multiple parameters, saving you the brackets.
    def expand_into_array(parameter)
      lambda { |*args| { parameter => args.size == 1 ? args[0] : args } }
    end

    # The lambda for boolean switches (readonly and lock). Will default
    # to true when no argument has been given.
    def default_to_true(parameter)
      lambda { |*args| { parameter => args.size == 0 ? true : args[0] } }
    end

    # For the +all+-method, an empty hash will be the default when no
    # parameters have been given. Otherwise, it just accepts just one
    # parameter.
    def default_to_empty_hash
      lambda { |*args| args[0] || {} }
    end

  end

end

ActiveRecord::Base.extend(BasicNamedScopes) if defined?(ActiveRecord)
