using BackEnd.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

[Route("api/artistas")]
[ApiController]
public class ArtistController : ControllerBase
{
    private readonly AppDbContext _context;

    public ArtistController(AppDbContext context)
    {
        _context = context;
    }

    [AllowAnonymous] 
    [HttpGet]
    public async Task<IActionResult> ObtenerTodosLosArtistas()
    {
        var artistas = await _context.dtArtistas
            .FromSqlRaw("SELECT * FROM dtArtistas WHERE Eliminado = 0")
            .Select(a => new
            {
                a.IDArtista,
                a.Nombre,
                a.Apellidos,
                a.Sexo,
                a.LinkFoto,
                a.Biografia
            })
            .ToListAsync();

        var artistasSinDuplicados = artistas
            .GroupBy(a => new
            {
                a.Nombre,
                a.Apellidos,
                a.Sexo,
                a.LinkFoto,
                a.Biografia
            })
            .Select(g => g.OrderBy(a => a.IDArtista).First()) 
            .ToList();

        return Ok(artistasSinDuplicados);
    }
}
