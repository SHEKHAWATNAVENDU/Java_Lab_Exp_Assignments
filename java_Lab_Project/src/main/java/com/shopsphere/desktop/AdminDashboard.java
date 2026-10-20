package com.shopsphere.desktop;

import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.ListSelectionModel;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.table.DefaultTableModel;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;

/**
 * Modern Swing Administrative Desktop Application.
 * Applies OS-native Pluggable Look and Feel (PLAF) and uses JTable inside JScrollPane
 * organized within a JTabbedPane across Products, Orders, and Customers.
 */
public class AdminDashboard extends JFrame {

    private final String adminEmail;
    private JTabbedPane tabbedPane;
    private DefaultTableModel productsModel;
    private DefaultTableModel ordersModel;
    private DefaultTableModel customersModel;

    public AdminDashboard(String adminEmail) {
        this.adminEmail = adminEmail;

        // 1. Enforce native system Look and Feel before initializing components
        LoginFrame.applySystemLookAndFeel();

        // 2. Initialize UI Components
        initComponents();
    }

    private void initComponents() {
        setTitle("BikeIsNice Administrator Control Center");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(1000, 680);
        setMinimumSize(new Dimension(850, 500));
        setLocationRelativeTo(null);

        JPanel mainPanel = new JPanel(new BorderLayout(10, 10));
        mainPanel.setBorder(BorderFactory.createEmptyBorder(12, 16, 12, 16));

        // Header Bar
        JPanel headerPanel = new JPanel(new BorderLayout());
        headerPanel.setBorder(BorderFactory.createCompoundBorder(
            BorderFactory.createMatteBorder(0, 0, 1, 0, new Color(203, 213, 225)),
            BorderFactory.createEmptyBorder(0, 0, 10, 0)
        ));

        JLabel titleLabel = new JLabel("BikeIsNice Enterprise Admin Dashboard");
        titleLabel.setFont(new Font("Segoe UI", Font.BOLD, 20));
        titleLabel.setForeground(new Color(15, 23, 42));

        JPanel userInfoPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 10, 0));
        JLabel userLabel = new JLabel("Administrator: " + adminEmail);
        userLabel.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        userLabel.setForeground(new Color(71, 85, 105));

        JButton logoutButton = new JButton("Logout");
        logoutButton.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        logoutButton.addActionListener(e -> {
            dispose();
            SwingUtilities.invokeLater(() -> new LoginFrame().setVisible(true));
        });

        userInfoPanel.add(userLabel);
        userInfoPanel.add(logoutButton);

        headerPanel.add(titleLabel, BorderLayout.WEST);
        headerPanel.add(userInfoPanel, BorderLayout.EAST);
        mainPanel.add(headerPanel, BorderLayout.NORTH);

        // Center: JTabbedPane Organizing Products, Orders, Customers
        tabbedPane = new JTabbedPane();
        tabbedPane.setFont(new Font("Segoe UI", Font.BOLD, 13));

        // Tab 1: Products Management
        tabbedPane.addTab("Products Management", createProductsPanel());

        // Tab 2: Orders Management
        tabbedPane.addTab("Orders Management", createOrdersPanel());

        // Tab 3: Customers Management
        tabbedPane.addTab("Customers Management", createCustomersPanel());

        mainPanel.add(tabbedPane, BorderLayout.CENTER);

        // Bottom Status Bar
        JPanel statusPanel = new JPanel(new BorderLayout());
        statusPanel.setBorder(BorderFactory.createEmptyBorder(6, 4, 2, 4));
        JLabel statusLabel = new JLabel("Connected to MySQL Database: shopsphere | System Status: Active | All services operational");
        statusLabel.setFont(new Font("Segoe UI", Font.PLAIN, 11));
        statusLabel.setForeground(new Color(100, 116, 139));
        statusPanel.add(statusLabel, BorderLayout.WEST);

        mainPanel.add(statusPanel, BorderLayout.SOUTH);

        setContentPane(mainPanel);
    }

    private JPanel createProductsPanel() {
        JPanel panel = new JPanel(new BorderLayout(8, 8));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Toolbar
        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 4));
        JButton addBtn = new JButton("Add Product");
        JButton restockBtn = new JButton("Restock (+10)");
        JButton deleteBtn = new JButton("Delete Product");
        JTextField searchField = new JTextField(15);
        JButton searchBtn = new JButton("Search");

        toolbar.add(addBtn);
        toolbar.add(restockBtn);
        toolbar.add(deleteBtn);
        toolbar.add(Box.createHorizontalStrut(15));
        toolbar.add(new JLabel("Search SKU/Name:"));
        toolbar.add(searchField);
        toolbar.add(searchBtn);

        panel.add(toolbar, BorderLayout.NORTH);

        // JTable inside JScrollPane for Products
        String[] columns = {"Product ID", "SKU", "Bike Name", "Category", "Price ($)", "Sale Price ($)", "Stock Qty", "Status"};
        Object[][] data = {
            {"1", "BIKE-ROAD-001", "Apex Carbon Aero Road Bike", "Road Bikes", "2499.00", "2299.00", "15", "active"},
            {"2", "BIKE-MTB-002", "TrailBlazer Full-Suspension 29er MTB", "Mountain Bikes", "1899.00", "-", "12", "active"},
            {"3", "BIKE-EBK-003", "VoltDrive Commuter E-Bike 750W", "Electric Bikes", "1699.00", "1499.00", "8", "active"},
            {"4", "BIKE-GRV-004", "TerraGravel Explorer All-Road Bike", "Gravel Bikes", "1299.00", "-", "20", "active"},
            {"5", "BIKE-MTB-005", "Summit Stealth Hardtail MTB 27.5\"", "Mountain Bikes", "899.00", "799.00", "25", "active"},
            {"6", "BIKE-ACC-007", "AeroVent MIPS Pro Cycling Helmet", "Cycling Gear", "149.99", "129.99", "45", "active"}
        };

        productsModel = new DefaultTableModel(data, columns) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false; // read-only directly in table
            }
        };

        JTable table = new JTable(productsModel);
        table.setRowHeight(26);
        table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        table.getTableHeader().setFont(new Font("Segoe UI", Font.BOLD, 12));

        // Action Listener for Restock
        restockBtn.addActionListener(e -> {
            int selectedRow = table.getSelectedRow();
            if (selectedRow >= 0) {
                int currentStock = Integer.parseInt(productsModel.getValueAt(selectedRow, 6).toString());
                productsModel.setValueAt(String.valueOf(currentStock + 10), selectedRow, 6);
                JOptionPane.showMessageDialog(this, "Stock updated to " + (currentStock + 10) + " units.", "Stock Updated", JOptionPane.INFORMATION_MESSAGE);
            } else {
                JOptionPane.showMessageDialog(this, "Please select a product row from the table.", "No Selection", JOptionPane.WARNING_MESSAGE);
            }
        });

        addBtn.addActionListener(e -> {
            String name = JOptionPane.showInputDialog(this, "Enter Product Name:");
            if (name != null && !name.trim().isEmpty()) {
                String sku = "SKU-CUSTOM-" + (productsModel.getRowCount() + 1);
                productsModel.addRow(new Object[]{String.valueOf(productsModel.getRowCount() + 1), sku, name, "General", "99.00", "-", "20", "active"});
            }
        });

        deleteBtn.addActionListener(e -> {
            int selectedRow = table.getSelectedRow();
            if (selectedRow >= 0) {
                productsModel.removeRow(selectedRow);
                JOptionPane.showMessageDialog(this, "Product removed from catalog.", "Deleted", JOptionPane.INFORMATION_MESSAGE);
            } else {
                JOptionPane.showMessageDialog(this, "Please select a row to delete.", "No Selection", JOptionPane.WARNING_MESSAGE);
            }
        });

        JScrollPane scrollPane = new JScrollPane(table);
        panel.add(scrollPane, BorderLayout.CENTER);
        return panel;
    }

    private JPanel createOrdersPanel() {
        JPanel panel = new JPanel(new BorderLayout(8, 8));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Toolbar
        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 4));
        JButton processBtn = new JButton("Set Processing");
        JButton deliverBtn = new JButton("Mark Delivered");
        JButton cancelBtn = new JButton("Cancel Order");

        toolbar.add(processBtn);
        toolbar.add(deliverBtn);
        toolbar.add(cancelBtn);

        panel.add(toolbar, BorderLayout.NORTH);

        // JTable inside JScrollPane for Orders
        String[] columns = {"Order ID", "Order Number", "Customer Name", "Customer Email", "Subtotal ($)", "Total Charged ($)", "Status", "Date"};
        Object[][] data = {
            {"1", "ORD-2026-1001", "Jane Doe", "customer@shopsphere.com", "999.99", "1,049.49", "delivered", "2026-10-05 14:22"},
            {"2", "ORD-2026-1002", "Michael Smith", "michael.s@example.com", "699.00", "744.92", "pending", "2026-10-06 08:15"},
            {"3", "ORD-2026-1003", "Sarah Jenkins", "sarah.j@example.com", "249.98", "269.98", "processing", "2026-10-06 02:40"},
            {"4", "ORD-2026-1004", "Robert Davis", "rdavis@example.org", "129.99", "150.39", "cancelled", "2026-10-04 19:10"}
        };

        ordersModel = new DefaultTableModel(data, columns) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };

        JTable table = new JTable(ordersModel);
        table.setRowHeight(26);
        table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        table.getTableHeader().setFont(new Font("Segoe UI", Font.BOLD, 12));

        deliverBtn.addActionListener(e -> {
            int selectedRow = table.getSelectedRow();
            if (selectedRow >= 0) {
                ordersModel.setValueAt("delivered", selectedRow, 6);
                JOptionPane.showMessageDialog(this, "Order marked as Delivered.", "Status Updated", JOptionPane.INFORMATION_MESSAGE);
            } else {
                JOptionPane.showMessageDialog(this, "Please select an order to update.", "No Selection", JOptionPane.WARNING_MESSAGE);
            }
        });

        processBtn.addActionListener(e -> {
            int selectedRow = table.getSelectedRow();
            if (selectedRow >= 0) {
                ordersModel.setValueAt("processing", selectedRow, 6);
                JOptionPane.showMessageDialog(this, "Order updated to Processing.", "Status Updated", JOptionPane.INFORMATION_MESSAGE);
            } else {
                JOptionPane.showMessageDialog(this, "Please select an order to update.", "No Selection", JOptionPane.WARNING_MESSAGE);
            }
        });

        cancelBtn.addActionListener(e -> {
            int selectedRow = table.getSelectedRow();
            if (selectedRow >= 0) {
                ordersModel.setValueAt("cancelled", selectedRow, 6);
                JOptionPane.showMessageDialog(this, "Order cancelled.", "Order Cancelled", JOptionPane.WARNING_MESSAGE);
            } else {
                JOptionPane.showMessageDialog(this, "Please select an order to cancel.", "No Selection", JOptionPane.WARNING_MESSAGE);
            }
        });

        JScrollPane scrollPane = new JScrollPane(table);
        panel.add(scrollPane, BorderLayout.CENTER);
        return panel;
    }

    private JPanel createCustomersPanel() {
        JPanel panel = new JPanel(new BorderLayout(8, 8));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Toolbar
        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 4));
        JButton viewBtn = new JButton("View Details");
        JButton deactivateBtn = new JButton("Toggle Status");

        toolbar.add(viewBtn);
        toolbar.add(deactivateBtn);

        panel.add(toolbar, BorderLayout.NORTH);

        // JTable inside JScrollPane for Customers
        String[] columns = {"User ID", "First Name", "Last Name", "Email Address", "Phone", "Role", "Status", "Registered Date"};
        Object[][] data = {
            {"1", "Admin", "User", "admin@shopsphere.com", "555-0100", "admin", "active", "2026-10-01"},
            {"2", "Jane", "Doe", "customer@shopsphere.com", "555-0101", "customer", "active", "2026-10-02"},
            {"3", "Michael", "Smith", "michael.s@example.com", "555-0142", "customer", "active", "2026-10-03"},
            {"4", "Sarah", "Jenkins", "sarah.j@example.com", "555-0199", "customer", "active", "2026-10-04"},
            {"5", "Robert", "Davis", "rdavis@example.org", "555-0205", "customer", "inactive", "2026-10-04"}
        };

        customersModel = new DefaultTableModel(data, columns) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };

        JTable table = new JTable(customersModel);
        table.setRowHeight(26);
        table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        table.getTableHeader().setFont(new Font("Segoe UI", Font.BOLD, 12));

        deactivateBtn.addActionListener(e -> {
            int selectedRow = table.getSelectedRow();
            if (selectedRow >= 0) {
                String current = customersModel.getValueAt(selectedRow, 6).toString();
                String updated = "active".equalsIgnoreCase(current) ? "inactive" : "active";
                customersModel.setValueAt(updated, selectedRow, 6);
                JOptionPane.showMessageDialog(this, "Customer status updated to: " + updated, "Status Changed", JOptionPane.INFORMATION_MESSAGE);
            } else {
                JOptionPane.showMessageDialog(this, "Please select a customer row.", "No Selection", JOptionPane.WARNING_MESSAGE);
            }
        });

        JScrollPane scrollPane = new JScrollPane(table);
        panel.add(scrollPane, BorderLayout.CENTER);
        return panel;
    }

    public static void main(String[] args) {
        // Enforce PLAF prior to initiating UI components
        LoginFrame.applySystemLookAndFeel();

        SwingUtilities.invokeLater(() -> {
            AdminDashboard dashboard = new AdminDashboard("admin@shopsphere.com");
            dashboard.setVisible(true);
        });
    }
}

