# Basic named scopes for ActiveRecord. Propagates the parameters of the
# find-method as named scopes, for easy reusability and prettier code.
#
# Instead of writing:
# 
#   Post.all(:conditions => { :published => true }, :select => :title, :includes => :author)
#
# You can now write:
#
#   Post.conditions(:published => true).select(:title).include(:author)
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
#   Post.include(:author, :comments).conditions("name LIKE ?", query)
#
# The +read_only+ and +lock+ scopes default to true, but can be adjusted.
#
#   Post.readonly         # => same as Post.all(:readonly => true)
#   Post.readonly(false)  # => same as Post.all(:readonly => false)
#
module BasicNamedScopes

  FIND_PARAMETERS       = [:conditions, :order, :group, :having, :limit, :offset, :joins, :include, :select, :from]
  FIND_BOOLEAN_SWITCHES = [:readonly, :lock]

  def self.extended(record)
    FIND_PARAMETERS.each do |parameter|
      record.named_scope(parameter, lambda { |*args| { parameter => args.size == 1 ? args.first : args } })
    end
    FIND_BOOLEAN_SWITCHES.each do |parameter|
      record.named_scope(parameter, lambda { |*args| { parameter => args.size == 0 ? true : args[0] } })
    end
    record.named_scope(:all, lambda { |*args| args[0] || {} })
  end

end

if defined? ActiveRecord
  ActiveRecord::Base.extend(BasicNamedScopes)
end
