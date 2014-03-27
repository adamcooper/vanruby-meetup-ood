class Symmetry

  def not_symmetrical(input_value)
    perform_logic
    @value = input_value
    update_values
  end

  def symmetrical(input_value)
    perform_logic
    set_value(input_value)
    update_values
  end
end





class Communication

  def not_talkative
    @rate = @country.present? ? @state.present? ? calculate_rate(@country, @state) : calculate_rate(@country) : nil
  end

  def communicative
    if @country.present?
      @rate = calculate_rate(@country, @state)
    else
      @rate = nil
    end
  end
end




class PrincipleViolations
  attr_accessor :parts

  def tune_up
     items.each do |item|
       case item
       when Tire
         item.pump_up
       when SparkPlug
         item.clean
       when SteeringWheel
         item.tighten
       end
     end
  end
end






class BetterPrinciples
  attr_accessor :parts

  def tune_up
    items.each { |item| item.tune_up }
  end
end

class CarPart
  def tune_up
    "tuning up"
  end
end

class Tire < CarPart
  def tune_up
    super + " tire"
  end
end


class CarPartWithFlippedDependency
  def tune_up
    puts "tuning up #{part_name}"
  end

  def item_name
    class.to_s.downcase
  end
end
class SparkPlug < CarPartWithFlippedDependency
  def item_name
    "car part"
  end
end

RemotePartAdapter = Struct.new(:remote_part)

  def tune_up
    remote_part.perform_tuneup
  end
end
