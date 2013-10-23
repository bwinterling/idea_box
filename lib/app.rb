require 'idea_box'

class IdeaBoxApp < Sinatra::Base

  set :method_override, true
  set :root, 'lib/app'

  # configure :development do
  #   register Sinatra::Reloader
  # end

  get '/' do
    # ideas = IdeaStore.all.sort
    ideas = IdeaStore.all_for_current_group.sort
    erb :index, locals: {
        ideas: ideas,
        idea: Idea.new,
        tags: IdeaStore.all_tags,
        groups: IdeaStore.groups,
        current_group: IdeaStore.current_group
      }
  end

  post '/' do
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  get '/tags/:tag' do |tag|
    ideas = IdeaStore.grouped_by_tags(tag)
    erb :by_tags, locals: {
        ideas: ideas,
        idea: Idea.new,
        tags: IdeaStore.all_tags,
        groups: IdeaStore.groups,
        current_group: IdeaStore.current_group
      }
  end

  get '/dates/:date' do |date|
    ideas = IdeaStore.grouped_by_dates(date)
    erb :by_date, locals: {
        ideas: ideas,
        idea: Idea.new,
        tags: IdeaStore.all_tags,
        groups: IdeaStore.groups,
        current_group: IdeaStore.current_group
      }
  end

  get '/search' do
    erb :search, locals: {
        ideas: IdeaStore.search_by(params[:criteria]),
        tags: IdeaStore.all_tags,
        groups: IdeaStore.groups,
        current_group: IdeaStore.current_group
      }
  end

  get '/date' do
    erb :by_date, locals: {
        ideas: IdeaStore.grouped_by_tags,
        idea: Idea.new,
        tags: IdeaStore.all_tags,
        groups: IdeaStore.groups,
        current_group: IdeaStore.current_group
      }
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {
        idea: idea,
        tags: IdeaStore.all_tags,
        groups: IdeaStore.groups,
        current_group: IdeaStore.current_group
      }
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params["idea"])
    redirect '/'
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  get '/group/:group' do |group|
    IdeaStore.current_group = group
    redirect '/'
  end

  not_found do
    erb :error
  end

end
