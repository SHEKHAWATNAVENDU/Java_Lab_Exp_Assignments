package com.shopsphere.desktop;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;

/**
 * Modern Swing Desktop Administrative Login Screen.
 * Demonstrates Pluggable Look and Feel (PLAF) initialization before component creation.
 */
public class LoginFrame extends JFrame {

    private JTextField emailField;
    private JPasswordField passwordField;
    private JButton loginButton;
    private JButton cancelButton;

    public LoginFrame() {
        // 1. Programmatically apply Pluggable Look and Feel (PLAF) for native OS styling
        applySystemLookAndFeel();

        // 2. Initialize UI components
        initComponents();
    }

    public static void applySystemLookAndFeel() {
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {
            System.err.println("Failed to set native system look and feel: " + e.getMessage());
        }
    }

    private void initComponents() {
        setTitle("BikeIsNice - Administrator Desktop Login");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(450, 320);
        setResizable(false);
        setLocationRelativeTo(null);

        JPanel mainPanel = new JPanel(new BorderLayout(15, 15));
        mainPanel.setBorder(BorderFactory.createEmptyBorder(20, 25, 20, 25));

        // Header Panel
        JPanel headerPanel = new JPanel(new BorderLayout());
        JLabel titleLabel = new JLabel("BikeIsNice Manager", JLabel.CENTER);
        titleLabel.setFont(new Font("Segoe UI", Font.BOLD, 18));
        titleLabel.setForeground(new Color(15, 23, 42));

        JLabel subtitleLabel = new JLabel("Store Administrator Authentication", JLabel.CENTER);
        subtitleLabel.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        subtitleLabel.setForeground(new Color(100, 116, 139));

        headerPanel.add(titleLabel, BorderLayout.NORTH);
        headerPanel.add(subtitleLabel, BorderLayout.SOUTH);
        mainPanel.add(headerPanel, BorderLayout.NORTH);

        // Form Panel
        JPanel formPanel = new JPanel(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(8, 8, 8, 8);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        // Email
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.weightx = 0.3;
        JLabel emailLabel = new JLabel("Admin Email:");
        emailLabel.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        formPanel.add(emailLabel, gbc);

        gbc.gridx = 1;
        gbc.weightx = 0.7;
        emailField = new JTextField("admin@shopsphere.com", 18);
        emailField.setPreferredSize(new Dimension(200, 28));
        formPanel.add(emailField, gbc);

        // Password
        gbc.gridx = 0;
        gbc.gridy = 1;
        gbc.weightx = 0.3;
        JLabel passLabel = new JLabel("Password:");
        passLabel.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        formPanel.add(passLabel, gbc);

        gbc.gridx = 1;
        gbc.weightx = 0.7;
        passwordField = new JPasswordField(18);
        passwordField.setText("password");
        passwordField.setPreferredSize(new Dimension(200, 28));
        formPanel.add(passwordField, gbc);

        mainPanel.add(formPanel, BorderLayout.CENTER);

        // Action Buttons Panel
        JPanel buttonPanel = new JPanel();
        loginButton = new JButton("Login");
        loginButton.setFont(new Font("Segoe UI", Font.BOLD, 12));
        loginButton.setPreferredSize(new Dimension(100, 32));

        cancelButton = new JButton("Exit");
        cancelButton.setPreferredSize(new Dimension(90, 32));

        buttonPanel.add(loginButton);
        buttonPanel.add(cancelButton);
        mainPanel.add(buttonPanel, BorderLayout.SOUTH);

        // Event Handlers
        loginButton.addActionListener(e -> performLogin());
        cancelButton.addActionListener(e -> System.exit(0));
        passwordField.addActionListener(e -> performLogin());

        setContentPane(mainPanel);
    }

    private void performLogin() {
        String email = emailField.getText().trim();
        String password = new String(passwordField.getPassword()).trim();

        if (email.isEmpty() || password.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please enter both email and password.", "Login Error", JOptionPane.ERROR_MESSAGE);
            return;
        }

        // Validate Administrator credentials
        if ("admin@shopsphere.com".equalsIgnoreCase(email) && !password.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Authentication successful! Welcome, Administrator.", "Access Granted", JOptionPane.INFORMATION_MESSAGE);
            dispose();

            // Open Admin Dashboard
            SwingUtilities.invokeLater(() -> {
                AdminDashboard dashboard = new AdminDashboard(email);
                dashboard.setVisible(true);
            });
        } else {
            JOptionPane.showMessageDialog(this, "Invalid credentials or insufficient administrator role.", "Authentication Failed", JOptionPane.ERROR_MESSAGE);
        }
    }

    public static void main(String[] args) {
        // Enforce PLAF prior to initiating UI components
        applySystemLookAndFeel();

        SwingUtilities.invokeLater(() -> {
            LoginFrame frame = new LoginFrame();
            frame.setVisible(true);
        });
    }
}

