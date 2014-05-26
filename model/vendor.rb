class Vendor < ERPMasterData
  def Vendor.duck
    Vendor.new :kind
  end
  
  def initialize kind
    @name = "#{NAMES[:vendor][:adj].sample} #{NAMES[:vendor][:noun].sample} #{NAMES[:cities].sample}"
    super kind
  end
end