package dao;

import model.Brand;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BrandDAO {

    public List<Brand> getAllBrands() {
        List<Brand> list = new ArrayList<>();
        String sql = "SELECT * FROM Brands WHERE isActive = 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Brand b = new Brand();
                b.setBrandId(rs.getInt("brandId"));
                b.setBrandName(rs.getString("brandName"));
                b.setLogo(rs.getString("logo"));
                b.setIsActive(rs.getBoolean("isActive"));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
