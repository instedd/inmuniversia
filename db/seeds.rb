# Added by Refinery CMS Pages extension
Refinery::Pages::Engine.load_seed

# Added by Refinery CMS Vaccines extension
Refinery::Vaccines::Engine.load_seed

# Generate initial admin user as initial Refinery setup generates redirect loop
admin = User.create email: 'admin@example.com', password: 'ChangeMe'
admin.add_role :refinery
admin.add_role :superuser