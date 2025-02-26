module UsersHelper
  def roles_for_select(show_all = false)
    options = User.roles.keys.map { |role| [ role.titleize, role ] }
    options.unshift([ "All", "" ]) if show_all
    options
  end
end
