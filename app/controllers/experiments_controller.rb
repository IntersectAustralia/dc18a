require 'zipruby'
require 'csv'

class ExperimentsController < ApplicationController
  before_filter :authenticate_user!

  #load_resource

  def new
    # Custom authentication strategy need custom flash message
    if params[:login_id]
      if current_user.nil?
        flash[:alert] = request.env['warden'].message
      else
        flash[:notice] = request.env['warden'].message
      end
    end

    @projects = current_user.projects
    @experiment = current_user.experiments.new
    @proteins = FluorescentProtein.core.to_a.to_json(only: [:id,:name])
    @selected = []
    @instrument = INSTRUMENTS[request.remote_ip]
  end

  def create
    protein_ids = params[:experiment].delete("fluorescent_protein_ids")
    @experiment = current_user.experiments.build(params[:experiment])
    @experiment.fluorescent_protein_ids = FluorescentProtein.ids_from_tokens(protein_ids)
    if @experiment.save
      flash[:notice] = "Experiment created"
      redirect_to project_path @experiment.project
    else
      flash[:alert] = "Please fill in all mandatory fields"
      @projects = current_user.projects
      @proteins = FluorescentProtein.core.to_a.to_json(only: [:id,:name])
      @selected = @experiment.fluorescent_proteins.to_a.to_json(only: [:id,:name])
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
    folder_name = localize(experiment.created_at, :format => :yyyymmdd) + "_P" + project.id.to_s + "_E" + experiment.expt_id.to_s + "_" + experiment.instrument

    # generate the metadata file
    csv = Tempfile.new("metadata.csv")
    CSV.open(csv.path, "wb") do |csv|
      csv << ["Project ID",
              "Project Name",
              "Project Create date",
              "Project Creator Staff Student/ID",
              "Project Creator",
              "Project Creator Email",
              "Project Creator Schools/Institute",
              "Project Supervisor",
              "Project Description",
              "Funded by Agency",
              "Funding Agency",
              "Other Funding Agency",
              "Experiment ID",
              "Experiment Name",
              "Experiment Date",
              "Instrument Name",
              "Lab Book No.",
              "Page No.",
              "Cell Type/Tissue",
              "Experiment Type",
              "Slides",
              "Dishes",
              "Multiwell Chambers",
              "Other Equipment",
              "Specify Other Equipment",
              "Fluorescent protein",
              "Fluorescent protein Other",
              "Specific Dyes",
              "Specify Specific Dyes",
              "Immunofluorescence" ]
      csv << [ project.id,
               project.name || "",
               localize(project.created_at, :format => :short),
               researcher.user_id,
               researcher.full_name,
               researcher.email,
               researcher.department,
               supervisor.full_name,
               project.description || "",
               project.funded_by_agency? ? "Yes" : "No",
               project.agency || "",
               project.other_agency || "",
               experiment.expt_id,
               experiment.expt_name || "",
               localize(experiment.created_at, :format => :short),
               experiment.instrument || "",
               experiment.lab_book_no || "",
               experiment.page_no || "",
               experiment.cell_type_or_tissue || "",
               experiment.expt_type || "",
               experiment.slides? ? "Yes" : "No",
               experiment.dishes? ? "Yes" : "No",
               experiment.multiwell_chambers? ? "Yes" : "No",
               experiment.other? ? "Yes" : "No",
               experiment.other_text || "",
               experiment.fluorescent_protein? ? "Yes" : "No",
               experiment.fluorescent_protein_text || "",
               experiment.specific_dyes? ? "Yes" : "No",
               experiment.specific_dyes_text || "",
               experiment.immunofluorescence? ? "Yes" : "No" ]
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
