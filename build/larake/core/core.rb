module LaRake

  def self.tmp_dir
    ".larake"
  end

  @@log_types =
  {
    :info => [:white, :bold],
    :milestone => [:yellow, :bold],
    :task => [:blue, :bold],
    :error => [:red, :bold]
  }

  def log(str, type = nil)
    puts type.nil? ? "* #{str}" : colorize_log("* #{str}", type)
  end

  private

  def colorize_log(str, type)
    if @@log_types.include? type then
      @@log_types[type].each{|color| str = str.send(color.to_s)}
    end

    str
  end
end
