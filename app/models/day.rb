class Day < ApplicationRecord
	belongs_to :customer, optional: true

  def days_list
    list = []
    if self.monday
      list.push("Monday")
    end
    if self.tuesday
      list.push("Tuesday")
    end
    if self.wednesday
      list.push("Wednesday")
    end
    if self.thursday
      list.push("Thursday")
    end
    if self.friday
      list.push("Friday")
    end
    list
  end
end
