guard 'shell' do
  watch(/site\/*/) { `jekyll` }
end

guard 'livereload' do
  watch(%r{\.public/.+\.(css|js|html)})
end

guard 'sass', :input => 'sass', :output => 'site', :style => :compressed, :hide_success => true
