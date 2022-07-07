resource "google_workflows_workflow" "workflow-1" {

    name = "workflow-1"
    region = "us-central1"
    project = "demo-project"
    source_contents = file("wf.yaml")
    
  
}