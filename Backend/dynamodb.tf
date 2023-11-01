resource "aws_dynamodb_table" "view_count_store"{
  name           = "views_count" 
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"
  

  attribute {
    name = "id"
    type = "S"

  }

  attribute {
    name = "views"
    type = "N"
  }


    global_secondary_index {
    name               = "views_index"
    hash_key           = "views"
    projection_type    = "ALL"
    read_capacity      = 1
    write_capacity     = 1
  }
 


 
  tags = {
    Name        = "resume_website_view_counter"
    
  }
}



