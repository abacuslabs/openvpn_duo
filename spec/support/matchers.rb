# encoding: utf-8
# frozen_string_literal: true

if defined?(ChefSpec)
  {
    openvpn_conf: %i(create delete)
  }.each do |matcher, actions|
    ChefSpec.define_matcher(matcher)

    actions.each do |action|
      define_method("#{action}_#{matcher}") do |name|
        ChefSpec::Matchers::ResourceMatcher.new(matcher, action, name)
      end
    end
  end
end
