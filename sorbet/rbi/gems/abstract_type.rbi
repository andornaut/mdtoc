# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/abstract_type/all/abstract_type.rbi
#
# abstract_type-0.0.7

module AbstractType
  def self.create_new_method(abstract_class); end
  def self.included(descendant); end
end
module AbstractType::AbstractMethodDeclarations
  def abstract_method(*names); end
  def abstract_singleton_method(*names); end
  def create_abstract_instance_method(name); end
  def create_abstract_singleton_method(name); end
end
