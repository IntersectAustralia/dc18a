require 'zipruby'
require 'csv'

class ExperimentsController < ApplicationController
  before_filter :authenticate_user!

  load_resource except: :create

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
    @core_proteins = FluorescentProtein.core.to_a.to_json(only: [:id,:name])
    @proteins = []
    @dyes = []
    @instrument = INSTRUMENTS[request.remote_ip]
  end

  def create
    protein_ids = params[:experiment].delete("fluorescent_protein_ids")
    dye_ids = params[:experiment].delete("specific_dye_ids")
    @experiment = current_user.experiments.build(params[:experiment])
    @experiment.fluorescent_protein_ids = FluorescentProtein.ids_from_tokens(protein_ids)
    @experiment.specific_dye_ids = SpecificDye.ids_from_tokens(dye_ids)
    if @experiment.save
      flash[:notice] = "Experiment created"
      redirect_to project_path @experiment.project
    else
      flash[:alert] = "Please fill in all mandatory fields"
      @projects = current_user.projects
      @core_proteins = FluorescentProtein.core.to_a.to_json(only: [:id,:name])
      @proteins = @experiment.fluorescent_proteins.to_a.to_json(only: [:id,:name])
      @dyes = @experiment.specific_dyes.to_a.to_json(only: [:id,:name])
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
    owner = experiment.user
    folder_name = "#{localize(experiment.created_at, :format => :yyyymmdd)}_P#{project.id}_E#{experiment.expt_id}_#{experiment.instrument}_#{owner.last_name}_#{owner.first_name}"

    # generate the metadata file
    csv = Tempfile.new("metadata.csv")
    CSV.open(csv.path, "wb") do |csv|
      csv << ["Project ID",
              "Project Name",
              "Project Create date",
              "Project Creator Staff Student/ID",
              "Project Creator First Name",
              "Project Creator Last Name",
              "Project Creator Email",
              "Project Creator Schools/Institute",
              "Project Supervisor First Name",
              "Project Supervisor Last Name",
              "Project Description",
              "Funded by Agency",
              "Funding Agency",
              "Other Funding Agency",
              "Experiment ID",
              "Experiment Name",
              "Experiment Date",
              "Experiment Owner First Name",
              "Experiment Owner Last Name",
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
              "Specify Fluorescent Proteins",
              "Specific Dyes",
              "Specify Specific Dyes",
              "Immunofluorescence" ]
      csv << [ project.id,
               project.name || "",
               localize(project.created_at, :format => :short),
               researcher.user_id,
               researcher.first_name,
               researcher.last_name,
               researcher.email,
               researcher.department,
               supervisor.first_name,
               supervisor.last_name,
               project.description || "",
               project.funded_by_agency? ? "Yes" : "No",
               project.agency || "",
               project.other_agency || "",
               experiment.expt_id,
               experiment.expt_name || "",
               localize(experiment.created_at, :format => :short),
               experiment.user.first_name,
               experiment.user.last_name,
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
               experiment.has_fluorescent_proteins? ? "Yes" : "No",
               experiment.fluorescent_proteins.pluck(:name) || "",
               experiment.has_specific_dyes? ? "Yes" : "No",
               experiment.specific_dyes.pluck(:name) || "",
               experiment.immunofluorescence? ? "Yes" : "No" ]
    end

    # generate the zip file
    file_name = folder_name + ".zip"
    t = Tempfile.new(file_name)
    Zip::Archive.open(t.path) do |z|
      z.add_dir(folder_name)
      included_file_name = "#{folder_name}/#{folder_name}_metadata.csv"
      z.add_file(included_file_name, csv.path)
    end
    send_file t.path, :type => 'application/zip',
                      :disposition => 'attachment',
                      :filename => file_name
    t.close
  end

end
