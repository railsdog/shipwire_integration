module Factories
	class << self
		def error_send_shipment_response
			{ "SubmitOrderResponse" =>
			  {
			  	"Status" => "Error",
			  	"ErrorMessage" => "<![CDATA[StoreAccountName, EmailAddress, or Username is required]]>"
			  }
			}
		end

		def success_send_shipment_response
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

		def success_shipment_tracking_response
			{
			  "TrackingUpdateResponse" => {
			    "Status" => "0",
			    "Order" => [
			      {
			        "id" => "40298",
			        "shipwireId" => "1234567890-1234567-1",
			        "warehouse" => "Chicago",
			        "shipped" => "NO",
			        "shipDate" => "2011-03-14 11:11:40",
			        "expectedDeliveryDate" => "2011-03-22 00:00:00",
			        "returned" => "NO",
			        "href" => "https://app.shipwire.com/c/t/xxx1:yyy1",
			        "affiliateStatus" => "canceled",
			        "manuallyEdited" => "NO"
			      },
			      {
			        "id" => "40298",
			        "shipwireId" => "1234567890-1234568-1",
			        "warehouse" => "Philadelphia",
			        "shipped" => "YES",
			        "shipper" => "USPS FC",
			        "shipperFullName" => "USPS First-Class Mail Parcel + Delivery Confirmation",
			        "shipDate" => "2011-03-15 10:40:06",
			        "delivered" => "YES",
			        "expectedDeliveryDate" => "2011-03-22 00:00:00",
			        "handling" => "0.00",
			        "shipping" => "4.47",
			        "packaging" => "0.00",
			        "total" => "4.47",
			        "returned" => "YES",
			        "returnDate" => "2011-05-04 17:33:25",
			        "returnCondition" => "GOOD",
			        "href" => "https://app.shipwire.com/c/t/xxx1:yyy2",
			        "affiliateStatus" => "shipwireFulfilled",
			        "manuallyEdited" => "NO",
			        "TrackingNumber" => {
			          "carrier" => "USPS",
			          "delivered" => "YES",
			          "deliveryDate" => "2011-03-21 17:10:00",
			          "href" => "http://trkcnfrm1.smi.usps.com/PTSInternetWeb/InterLabelInquiry.do?origTrackNum=9400110200793472606087",
			          "#text" => "9400110200793472606087"
			        }
			      },
			      {
			        "id" => "40298",
			        "shipwireId" => "1234567890-1234569-1",
			        "warehouse" => "Chicago",
			        "shipped" => "YES",
			        "shipper" => "USPS FC",
			        "shipperFullName" => "USPS First-Class Mail Parcel + Delivery Confirmation",
			        "shipDate" => "2011-04-08 09:33:10",
			        "delivered" => "NO",
			        "expectedDeliveryDate" => "2011-04-15 00:00:00",
			        "handling" => "0.00",
			        "shipping" => "4.47",
			        "packaging" => "0.00",
			        "total" => "4.47",
			        "returned" => "NO",
			        "href" => "https://app.shipwire.com/c/t/xxx1:yyy3",
			        "affiliateStatus" => "shipwireFulfilled",
			        "manuallyEdited" => "NO",
			        "TrackingNumber" => {
			          "carrier" => "USPS",
			          "delivered" => "NO",
			          "href" => "http://trkcnfrm1.smi.usps.com/PTSInternetWeb/InterLabelInquiry.do?origTrackNum=9400110200793596422990",
			          "#text" => "9400110200793596422990"
			        }
			      }
			    ],
			    "TotalOrders" => "3",
			    "TotalShippedOrders" => "2",
			    "TotalProducts" => "8",
			    "Bookmark" => "2011-10-22 14:13:16",
			    "ProcessingTime" => {
			      "units" => "ms",
			      "#text" => "1192"
			    }
			  }
			}
		end
	end
end