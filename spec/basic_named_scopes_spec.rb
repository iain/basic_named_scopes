require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "BasicNamedScopes" do

  before :all do
    create_model :posts do
      with_columns do |table|
        table.boolean :published
        table.boolean :visible
        table.integer :author_id
      end
      belongs_to :author
    end
    create_model :authors do
      with_columns do |table|
        table.string :name
      end
      has_many :posts
    end
  end

  before :each do
    Post.delete_all
    @published   = Post.create!(:published => true)
    @unpublished = Post.create!(:published => false)
  end

  it "should make .all a named scope" do
    # Without parameters
    Post.all.class.should be_scope
    # With parameters
    Post.all(:conditions => {:published => true}).class.should be_scope
  end

  it "should make find parameters a named scope" do
    subject = Post.conditions(:published => true)
    subject.class.should be_scope
    subject.should == [ @published ]
  end

  it "should expand into array when using multiple parameters" do
    subject = Post.conditions("published = ?", true)
    subject.class.should be_scope
    subject.should == [ @published ]
  end

  it "should have a scope named 'with' but internally use 'include' as parameter" do
    Post.create!(:author => Author.create!)
    Author.should_receive(:find).and_return([])
    Post.with(:author).to_a
  end

  [:conditions, :order, :group, :having, :limit, :offset, :joins, :with, :select, :from].each do |option|
    it "should known #{option} ActiveRecord::Base.find" do
      Post.send(option).class.should be_scope
    end
  end

  it "should default to true for readonly" do
    subject = Post.readonly
    subject.class.should be_scope
    lambda { subject.first.save }.should raise_error(ActiveRecord::ReadOnlyRecord)
  end

  it "should accept a value for readonly" do
    subject = Post.readonly(false)
    subject.class.should be_scope
    lambda { subject.first.save }.should_not raise_error(ActiveRecord::ReadOnlyRecord)
  end

end
