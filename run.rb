load 'init.rb'

log = File.new "foodbroker_#{SF}.log", 'w'

log.puts "#{Time.now.strftime "%Y-%m-%d %H:%M:%S"} start"

load 'simulation/master_data.rb'

log.puts "#{Time.now.strftime "%Y-%m-%d %H:%M:%S"} master data created"
#load 'simulation/brokerage.rb'

#(DB.select {|l| l.instance_of? Logistics}).each {|l| puts l.rand_tracking_code}

#puts DB

conf = CONF['FoodBrokerage']
dates = (conf['Process']['date']['min']..conf['Process']['date']['max']).to_a
cases = (1..conf['Process']['growth']*SF)
  
store = FoodBroker2Sql.new
store.prepare!
  
cases.each do |i|
  print "." 
  puts SF if i % 100 == 0

  fb = FoodBrokerage.new dates[i*dates.size/cases.size]
  store.record fb.tdos
  cp = Complaints.new fb
  store.record cp.tdos
  log.puts "#{Time.now.strftime "%Y-%m-%d %H:%M:%S"} simulated #{i} cases" if i % (cases.last/10) == 0
end

store.record DB
log.puts "#{Time.now.strftime "%Y-%m-%d %H:%M:%S"} master data stored"

store.finish!

log.puts "#{Time.now.strftime "%Y-%m-%d %H:%M:%S"} end"

log.puts DomainData.stats

