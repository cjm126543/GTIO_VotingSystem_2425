using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using BackEnd.Models;
using BCrypt.Net;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

[Route("api/users")]
[ApiController]
public class UserController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly IConfiguration _configuration;

    public UserController(AppDbContext context, IConfiguration configuration)
    {
        _context = context;
        _configuration = configuration;
    }

  
    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] dtUsuarios userDto)
    {
        if (await _context.dtUsuarios.AnyAsync(u => u.Correo == userDto.Correo))
        {
            return BadRequest("Email is already in use.");
        }

        var user = new dtUsuarios
        {
            Nombre = userDto.Nombre,
            Apellidos = userDto.Apellidos,
            Correo = userDto.Correo,
            Contrasenia = BCrypt.Net.BCrypt.HashPassword(userDto.Contrasenia), // Hash the password
            IDRolUsuario = 1,
            Eliminado = false
        };

        _context.dtUsuarios.Add(user);
        await _context.SaveChangesAsync();

        return Ok(new { message = "User registered successfully!" });
    }


   
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest model)
    {
        var u = await _context.dtUsuarios.ToListAsync();
        var user = await _context.dtUsuarios.Include(u => u.IDRolUsuarioNavigation)
                    .FirstOrDefaultAsync(u => u.Correo == model.Email);
        
        if (user == null || !BCrypt.Net.BCrypt.Verify(model.Password, user.Contrasenia))
        {
            return Unauthorized(new { tok = "", userID = 0, puedeVotar = false, message = "Invalid email or password." });
        }

        var tokenUser = GenerateJwtToken(user);
        return Ok(new { token = tokenUser, userID = user.IDUsuario, puedeVotar = true, message = "Login success" });
    }

    /*    
        [Authorize]
        [HttpGet("profile")]
        public async Task<IActionResult> GetUserProfile()
        {
            var userEmail = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userEmail == null) return Unauthorized();

            var user = await _context.dtUsuarios.Include(u => u.IDRolUsuarioNavigation)
                        .FirstOrDefaultAsync(u => u.Correo == userEmail);
            if (user == null) return NotFound();

            return Ok(new
            {
                user.Nombre,
                user.Apellidos,
                user.Correo,
                Role = user.IDRolUsuarioNavigation?.DescripcionRol
            });
        }*/

  
/*    [Authorize(Roles = "Admin")]
    [HttpPut("update-role/{id}")]
    public async Task<IActionResult> UpdateUserRole(int id, [FromBody] int newRoleId)
    {
        var user = await _context.dtUsuarios.FindAsync(id);
        if (user == null) return NotFound("User not found.");

        var roleExists = await _context.msRolesUsuario.AnyAsync(r => r.IDRolUsuario == newRoleId);
        if (!roleExists) return BadRequest("Invalid role ID.");

        user.IDRolUsuario = newRoleId;
        await _context.SaveChangesAsync();

        return Ok(new { message = "User role updated successfully." });
    }
*/
    // JWT TOKEN GENERATION
    private string GenerateJwtToken(dtUsuarios user)
    {
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]!));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, user.Correo),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            new Claim(ClaimTypes.Role, user.IDRolUsuarioNavigation?.DescripcionRol ?? "Sin rol")
        };

        var token = new JwtSecurityToken(
            _configuration["Jwt:Issuer"],
            _configuration["Jwt:Issuer"],
            claims,
            expires: DateTime.UtcNow.AddHours(2),
            signingCredentials: creds
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}




public class LoginRequest
{
    public required string Email { get; set; }
    public required string Password { get; set; }
}

