module CustomersHelper
  def user_or_business_logged_in
    if session[:business_id] || session[:user_id]
    else
      flash[:notice] = "Not Authorized To View This Page"
      root_redirect_path
    end
  end

  def assign_user_id
    if customer_params[:user_id] == "" || customer_params[:user_id] == nil
      if session[:user_id]
        id = session[:user_id]
      end
    else
      id = customer_params[:user_id]
    end
  end

  def customer_business?
    @customer && @customer.user.business.id == session[:business_id]
  end

  def customer_user?
    @customer && @customer.user.id == session[:user_id]
  end

  def customer_user_logged_in?
    @customer && @logged_in_user && @logged_in_user.admin && @logged_in_user.business == @customer.business
  end


  def customer_allow_user_business_or_admin
    if customer_business? || customer_user? || customer_user_logged_in?
    else
      root_redirect_path
    end
  end

  def allow_only_user_and_admin
    if customer_user? || customer_user_logged_in?
    else
      root_redirect_path
    end
  end

  def display_true_false_value(input)
    return input ? "<i class='fa fa-check' aria-hidden='true'></i>".html_safe : "<i class='fa fa-times' aria-hidden='true'></i>".html_safe
  end
  def display_phone_number(number)
    number_to_phone(number, area_code: true)
  end 

  def us_states
    [
      ['AK', 'AK'],
      ['AL', 'AL'],
      ['AR', 'AR'],
      ['AZ', 'AZ'],
      ['CA', 'CA'],
      ['CO', 'CO'],
      ['CT', 'CT'],
      ['DC', 'DC'],
      ['DE', 'DE'],
      ['FL', 'FL'],
      ['GA', 'GA'],
      ['HI', 'HI'],
      ['IA', 'IA'],
      ['ID', 'ID'],
      ['IL', 'IL'],
      ['IN', 'IN'],
      ['KS', 'KS'],
      ['KY', 'KY'],
      ['LA', 'LA'],
      ['MA', 'MA'],
      ['MD', 'MD'],
      ['ME', 'ME'],
      ['MI', 'MI'],
      ['MN', 'MN'],
      ['MO', 'MO'],
      ['MS', 'MS'],
      ['MT', 'MT'],
      ['NC', 'NC'],
      ['ND', 'ND'],
      ['NE', 'NE'],
      ['NH', 'NH'],
      ['NJ', 'NJ'],
      ['NM', 'NM'],
      ['NV', 'NV'],
      ['NY', 'NY'],
      ['OH', 'OH'],
      ['OK', 'OK'],
      ['OR', 'OR'],
      ['PA', 'PA'],
      ['RI', 'RI'],
      ['SC', 'SC'],
      ['SD', 'SD'],
      ['TN', 'TN'],
      ['TX', 'TX'],
      ['UT', 'UT'],
      ['VA', 'VA'],
      ['VT', 'VT'],
      ['WA', 'WA'],
      ['WI', 'WI'],
      ['WV', 'WV'],
      ['WY', 'WY']
    ]
  end
end
