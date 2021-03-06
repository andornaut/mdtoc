# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/ice_nine/all/ice_nine.rbi
#
# ice_nine-0.11.2

module IceNine
  def self.deep_freeze!(object); end
  def self.deep_freeze(object); end
end
class IceNine::RecursionGuard
end
class IceNine::RecursionGuard::ObjectSet < IceNine::RecursionGuard
  def guard(object); end
  def initialize; end
end
class IceNine::RecursionGuard::Frozen < IceNine::RecursionGuard
  def guard(object); end
end
class IceNine::Freezer
  def self.[](mod); end
  def self.const_lookup(namespace); end
  def self.deep_freeze!(object); end
  def self.deep_freeze(object); end
  def self.find(name); end
  def self.guarded_deep_freeze(object, recursion_guard); end
end
class IceNine::Freezer::Object < IceNine::Freezer
  def self.freeze_instance_variables(object, recursion_guard); end
  def self.guarded_deep_freeze(object, recursion_guard); end
end
class IceNine::Freezer::NoFreeze < IceNine::Freezer
  def self.guarded_deep_freeze(object, _recursion_guard); end
end
class IceNine::Freezer::Array < IceNine::Freezer::Object
  def self.guarded_deep_freeze(array, recursion_guard); end
end
class IceNine::Freezer::FalseClass < IceNine::Freezer::NoFreeze
end
class IceNine::Freezer::Hash < IceNine::Freezer::Object
  def self.freeze_key_value_pairs(hash, recursion_guard); end
  def self.guarded_deep_freeze(hash, recursion_guard); end
end
class IceNine::Freezer::Hash::State < IceNine::Freezer::NoFreeze
end
class IceNine::Freezer::NilClass < IceNine::Freezer::NoFreeze
end
class IceNine::Freezer::Module < IceNine::Freezer::NoFreeze
end
class IceNine::Freezer::Numeric < IceNine::Freezer::NoFreeze
end
class IceNine::Freezer::Range < IceNine::Freezer::Object
  def self.guarded_deep_freeze(range, recursion_guard); end
end
class IceNine::Freezer::Rubinius < IceNine::Freezer::NoFreeze
end
class IceNine::Freezer::Struct < IceNine::Freezer::Array
end
class IceNine::Freezer::Symbol < IceNine::Freezer::NoFreeze
end
class IceNine::Freezer::TrueClass < IceNine::Freezer::NoFreeze
end
