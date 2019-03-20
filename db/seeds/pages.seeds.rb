# frozen_string_literal: true

about_body = <<-HTML
  <p>This is an experimental curriculum project designed to learn about how teachers can make effective use of well organized materials. We relied on ELA and math OER curriculum in grades 9–12 heavily for this pilot project. If you have any questions or feedback about the materials on this site, please contact us. We hope you enjoy using this site!</p>
HTML

Lcms::Engine::Page.create_with(body: about_body, title: 'About').find_or_create_by(slug: 'about')
Lcms::Engine::Page.create_with(body: about_body, title: 'Our People').find_or_create_by(slug: 'about_people')

pd_body = <<-HTML
  Professional Development
HTML

Lcms::Engine::Page
  .create_with(body: pd_body, title: 'Professional Development').find_or_create_by(slug: 'professional_development')

tos_body = <<-HTML
  <p>ToS here</p>
HTML

Lcms::Engine::Page.create_with(body: tos_body, title: 'Terms of Service').find_or_create_by(slug: 'tos')

privacy_body = <<-HTML
  <p>Privacy here</p>
HTML
Lcms::Engine::Page.create_with(body: privacy_body, title: 'Privacy Policy').find_or_create_by(slug: 'privacy')
