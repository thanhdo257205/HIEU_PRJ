package model;

import java.util.Date;
import java.util.List;

public class Order {

    private int orderId;
    private int userId;
    private Date orderDate;
    private double totalAmount;
    private String shippingAddress;
    private String phone;
    private String note;
    private String status;

    // Join info
    private String customerName;
    private List<OrderDetail> orderDetails;

    public Order() {
    }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public List<OrderDetail> getOrderDetails() { return orderDetails; }
    public void setOrderDetails(List<OrderDetail> orderDetails) { this.orderDetails = orderDetails; }

    public String getStatusText() {
        switch (status) {
            case "pending": return "Chờ xác nhận";
            case "confirmed": return "Đã xác nhận";
            case "shipping": return "Đang giao";
            case "delivered": return "Đã giao";
            case "cancelled": return "Đã hủy";
            default: return status;
        }
    }

    public String getStatusColor() {
        switch (status) {
            case "pending": return "#f59e0b";
            case "confirmed": return "#3b82f6";
            case "shipping": return "#8b5cf6";
            case "delivered": return "#10b981";
            case "cancelled": return "#ef4444";
            default: return "#6b7280";
        }
    }
}
