module Factories
	class << self
		def error_response
			{ "SubmitOrderResponse" =>
			  {
			  	"Status" => "Error",
			  	"ErrorMessage" => "<![CDATA[StoreAccountName, EmailAddress, or Username is required]]>"
			  }
			}
		end

		def success_response
			{
			    "SubmitOrderResponse" => {
			                  "Status" => "0",
			             "TotalOrders" => "1",
			              "TotalItems" => "0",
			           "TransactionId" => "1352214142-773022-1",
			        "OrderInformation" => {
			            "Order" => {
			                "WarningList" => {
			                    "Warning" => "\n          Could not verify shipping address\n"
			                },
			                   "Shipping" => {
			                    "Warehouse" => "(Pending)",
			                      "Service" => "(Pending)",
			                         "Cost" => "(Pending)"
			                },
			                     "number" => "R159875257",
			                         "id" => "1352214142-773022-1",
			                     "status" => "accepted"
			            }
			        },
			          "ProcessingTime" => {
			            "__content__" => "464",
			                  "units" => "ms"
			        }
			    }
			}			
		end
	end
end