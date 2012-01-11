class Color < String
  COLUMN_TYPE = :string
  HoboFields.register_type(:color, Color)
end

