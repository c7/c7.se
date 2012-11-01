guard 'shell' do
  watch(/site\/*/) { `jekyll` }
end

guard 'sass', :input => 'sass', :output => 'site', :style => :compressed, :hide_success => false
