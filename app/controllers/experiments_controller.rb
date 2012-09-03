class ExperimentsController < ApplicationController
  before_filter :authenticate_user!

  load_resource

  def new
    # Custom authentication strategy need custom flash message
    if params[:login_id] && params[:ip]
      if current_user.nil?
        flash[:alert] = request.env['warden'].message
      else
        flash[:notice] = request.env['warden'].message
        @instrument = INSTRUMENTS[params[:ip]]
      end
    end

    @projects = current_user.projects
    @experiment = current_user.experiments.new
  end

  def create
    @experiment = current_user.experiments.build(params[:experiment])

    if @experiment.save
      flash[:notice] = "Experiment created"
      redirect_to root_path
    else
      flash[:alert] = "Please fill in all mandatory fields"
      @projects = current_user.projects
      render action: "new"
    end
  end

  def cancel
    redirect_to root_path
  end

  def download
    experiment = Experiment.find(params[:id])
    project = experiment.project
    researcher = project.user
    supervisor = project.supervisor

    # generate the metadata file
    csv = Tempfile.new("metadata.csv")
    File.open(csv.path, "w") do |f|
      f.puts("Project ID,"\
             "Project Name,"\
             "Project Create date,"\
             "Project Creator Staff Student/ID,"\
             "Project Creator,"\
             "Project Creator Email,"\
             "Project Creator Department/Institute,"\
             "Project Supervisor,"\
             "Project Description,"\
             "Funded by Agency,"\
             "Funding Agency,"\
             "Other Funding Agency,"\
             "Experiment ID,"\
             "Experiment Name,"\
             "Experiment Date,"\
             "Lab Book No.,"\
             "Page No.,"\
             "Cell Type/Tissue,"\
             "Experiment Type,"\
             "Slides,"\
             "Dishes,"\
             "Multiwell Chambers,"\
             "Other Equipment,"\
             "Specify Other Equipment,"\
             "Reporter Protein,"\
             "Reporter Protein Other,"\
             "Specific Dyes,"\
             "Specify Specific Dyes,"\
             "Immunofluorescence\n")
      f.puts(project.id + ",")
      f.puts(project.name + ",")
      f.puts(localize(project.created_at, :format => :short) + ",")
      f.puts(researcher.user_id + ",")
      f.puts(researcher.full_name + ",")
      f.puts(researcher.email + ",")
      f.puts(researcher.department + ",")
      f.puts(supervisor.full_name + ",")
      f.puts(project.description + ",")
    end

    # generate the zip file
    file_name = "pictures.zip"
    t = Tempfile.new("my-temp-filename-#{Time.now}")
    Zip::ZipOutputStream.open(t.path) do |z|
      image_list.each do |img|
        title = img.title
        title += ".jpg" unless title.end_with?(".jpg")
        z.put_next_entry(title)
        z.print IO.read(img.path)
      end
    end
    send_file t.path, :type => 'application/zip',
              :disposition => 'attachment',
              :filename => file_name
    t.close
  end

end
