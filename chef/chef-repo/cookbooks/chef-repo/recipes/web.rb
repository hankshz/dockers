template '/app.js' do
  source 'app.js.erb'
end

execute 'install_pm2' do
  command 'npm install pm2 -g'
end

execute 'start_appjs' do
  command 'pm2 start /app.js'
end
