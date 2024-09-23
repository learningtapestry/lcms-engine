# frozen_string_literal: true

%w(standard1 standard2 standard3).each do |standard|
  Lcms::Engine::Standard.create(name: standard)
end
