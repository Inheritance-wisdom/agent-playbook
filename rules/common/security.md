# Security Guidelines

## Mandatory Checks (Before ANY Commit)

- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user inputs validated
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (sanitized HTML)
- [ ] CSRF protection enabled
- [ ] Authentication/authorization verified
- [ ] Rate limiting on all endpoints
- [ ] Error messages don't leak sensitive data

## Secret Management

Never hardcode secrets. Use environment variables or a secret manager. Validate required secrets at startup. Rotate any exposed secrets immediately.

## Security Response Protocol

1. STOP immediately
2. Invoke `security-reviewer` agent
3. Fix CRITICAL issues before continuing
4. Rotate exposed secrets
5. Audit codebase for similar issues