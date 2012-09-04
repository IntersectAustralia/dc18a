require 'zipruby'

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
    folder_name = localize(experiment.created_at, :format => :yyyymmdd) + "_P" + project.id.to_s + "_E" + experiment.id.to_s + "_" + experiment.instrument

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
             "Immunofluorescence")
      f.print(project.id.to_s + ",")
      f.print((project.name || "") + ",")
      f.print(localize(project.created_at, :format => :short) + ",")
      f.print(researcher.user_id + ",")
      f.print(researcher.full_name + ",")
      f.print(researcher.email + ",")
      f.print(researcher.department + ",")
      f.print(supervisor.full_name + ",")
      f.print((project.description || "") + ",")
      f.print((project.funded_by_agency? ? "Yes" : "No") + ",")
      f.print((project.agency || "") + ",")
      f.print((project.other_agency || "") + ",")
      f.print(experiment.id.to_s + ",")
      f.print((experiment.expt_name || "") + ",")
      f.print(localize(experiment.created_at, :format => :short) + ",")
      f.print((experiment.lab_book_no || "") + ",")
      f.print((experiment.page_no || "") + ",")
      f.print((experiment.cell_type_or_tissue || "") + ",")
      f.print((experiment.expt_type || "") + ",")
      f.print((experiment.slides? ? "Yes" : "No") + ",")
      f.print((experiment.dishes? ? "Yes" : "No") + ",")
      f.print((experiment.multiwell_chambers? ? "Yes" : "No") + ",")
      f.print((experiment.other? ? "Yes" : "No") + ",")
      f.print((experiment.other_text || "") + ",")
      f.print((experiment.reporter_protein? ? "Yes" : "No") + ",")
      f.print((experiment.reporter_protein_text || "") + ",")
      f.print((experiment.specific_dyes? ? "Yes" : "No") + ",")
      f.print((experiment.specific_dyes_text || "") + ",")
      f.print((experiment.immunofluorescence? ? "Yes" : "No") + "\n")
    end

    # generate the zip file
    file_name = folder_name + ".zip"
    t = Tempfile.new(file_name)
    Zip::Archive.open(t.path) do |z|
      z.add_dir(folder_name)
      z.add_file("#{folder_name}/metadata.csv", csv.path)
    end
    send_file t.path, :type => 'application/zip',
                      :disposition => 'attachment',
                      :filename => file_name
    t.close
  end

end
