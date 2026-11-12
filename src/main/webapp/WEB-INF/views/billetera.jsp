<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Billetera digital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
          crossorigin="anonymous">
    <style>
        body {
            min-height: 100vh;
            background: #f4f7fb;
        }

        .wallet-header {
            background: linear-gradient(135deg, #0d6efd, #084298);
        }

        .amount {
            letter-spacing: -0.04em;
        }
    </style>
</head>
<body>
<header class="wallet-header text-white py-4 mb-4 shadow-sm">
    <div class="container">
        <p class="mb-1 text-white-50">T1 - Java Servlet y JSP</p>
        <h1 class="h2 mb-0">Billetera digital</h1>
    </div>
</header>

<main class="container pb-5">
    <div class="row g-4">
        <section class="col-lg-4" aria-labelledby="saldo-titulo">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body p-4">
                    <h2 id="saldo-titulo" class="h6 text-secondary">Saldo disponible</h2>
                    <p class="amount display-5 fw-bold text-primary mb-0">
                        S/ <fmt:formatNumber value="${saldo}"
                                             minFractionDigits="2"
                                             maxFractionDigits="2"/>
                    </p>
                </div>
            </div>
        </section>

        <section class="col-lg-8" aria-labelledby="movimiento-titulo">
            <div class="card border-0 shadow-sm">
                <div class="card-body p-4">
                    <h2 id="movimiento-titulo" class="h5 mb-3">Nuevo movimiento</h2>

                    <c:if test="${not empty mensajeExito}">
                        <div class="alert alert-success" role="status">
                            <c:out value="${mensajeExito}"/>
                        </div>
                    </c:if>

                    <c:if test="${not empty mensajeError}">
                        <div class="alert alert-danger" role="alert">
                            <c:out value="${mensajeError}"/>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/billetera"
                          method="post"
                          class="row g-3">
                        <div class="col-md-5">
                            <label for="tipo" class="form-label">Tipo</label>
                            <select id="tipo" name="tipo" class="form-select" required>
                                <option value="">Seleccione</option>
                                <option value="recarga">Recarga</option>
                                <option value="gasto">Gasto</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label for="monto" class="form-label">Monto (S/)</label>
                            <input id="monto"
                                   name="monto"
                                   type="number"
                                   class="form-control"
                                   min="0.01"
                                   step="0.01"
                                   inputmode="decimal"
                                   placeholder="0.00"
                                   required>
                        </div>

                        <div class="col-md-3 d-grid align-items-end">
                            <button type="submit" class="btn btn-primary">
                                Registrar
                            </button>
                        </div>
                    </form>
                    <p class="form-text mb-0 mt-3">
                        Solo se aceptan montos numéricos mayores que cero.
                    </p>
                </div>
            </div>
        </section>
    </div>

    <section class="card border-0 shadow-sm mt-4" aria-labelledby="historial-titulo">
        <div class="card-body p-4">
            <h2 id="historial-titulo" class="h5 mb-3">Historial de movimientos</h2>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th scope="col">Tipo</th>
                        <th scope="col">Monto</th>
                        <th scope="col">Fecha</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty movimientos}">
                            <tr>
                                <td colspan="3" class="text-center text-secondary py-4">
                                    Todavía no hay movimientos registrados.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${movimientos}" var="movimiento">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${movimiento.tipo eq 'Recarga'}">
                                                <span class="badge text-bg-success">Recarga</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge text-bg-danger">Gasto</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="fw-semibold">
                                        <c:if test="${movimiento.tipo eq 'Gasto'}">-</c:if>
                                        <c:if test="${movimiento.tipo eq 'Recarga'}">+</c:if>
                                        S/ <fmt:formatNumber value="${movimiento.monto}"
                                                             minFractionDigits="2"
                                                             maxFractionDigits="2"/>
                                    </td>
                                    <td><c:out value="${movimiento.fechaFormateada}"/></td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </section>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
        crossorigin="anonymous"></script>
</body>
</html>
