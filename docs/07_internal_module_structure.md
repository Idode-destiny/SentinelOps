# Phase 5: Internal Structure & Structural Boundary Enforcement

## C4 Level 4: SentinelOps Governance Backbone

---

## Objective

**Make the architecture enforceable at implementation level.**

Define:

- **Structural module boundaries**
- **Namespace isolation**
- **Allowed dependency directions**
- **Forbidden imports**
- **Authority containment rules**

**This phase does not define entities or schema.**

**It defines how engineering teams are prevented from violating architecture.**

---

## Structural Enforcement Philosophy

For SentinelOps as a centralized enterprise backbone, the correct enforcement model is:

**Hybrid Modular Core with Strict Boundary Rules**

**Meaning:**

- **Each container has its own internal module tree**
- **Cross container communication happens only via interface contracts**
- **No container can import another container's internal modules**
- **Ledger and Governance are physically isolated from Advisory and Policy**

**This can be implemented either as:**

---

## 1. Policy & Regulatory Engine

### Container Level 2
### Component Level 3
### File Level

```
policy-engine/
policy-engine/
│
├── repository/
│   ├── PolicyRepository.ts
│   ├── PolicyVersionStore.ts
│   └── RegulatoryMappingStore.ts
│
├── interpreter/
│   ├── PolicyInterpreter.ts
│   ├── ConditionParser.ts
│   └── EvaluationContextBuilder.ts
│
├── evaluation/
│   ├── PolicyEvaluator.ts
│   ├── RuleMatcher.ts
│   └── EvaluationResult.ts
│
├── conflict/
│   ├── ConflictResolver.ts
│   └── PriorityResolver.ts
│
├── domain/
│   ├── Policy.ts
│   ├── PolicyVersion.ts
│   └── PolicyStatus.ts
│
└── interfaces/
    ├── IPolicyEvaluationService.ts
    └── IPolicyRepository.ts
```

#### Rules:

- **evaluation cannot import from conflict directly**
- **domain cannot depend on repository**
- **interfaces expose only evaluation results**

---

## 2. Risk Engine

```
risk-engine/
risk-engine/
│
├── models/
│   ├── RiskModel.ts
│   ├── ThresholdDefinition.ts
│   └── RiskLevel.ts
│
├── calculation/
│   ├── RiskCalculator.ts
│   └── ScoringAlgorithm.ts
│
├── classification/
│   ├── RiskClassifier.ts
│   └── SeverityMapper.ts
│
├── store/
│   ├── RiskModelRepository.ts
│   └── RiskAssessmentStore.ts
│
└── interfaces/
    └── IRiskAssessmentService.ts
```

#### Rules:

- **calculation cannot write to advisory**
- **store isolated**
- **interfaces expose only RiskAssessmentResult**

---

## 3. Advisory Engine

```
advisory-engine/
advisory-engine/
│
├── composition/
│   ├── AdvisoryComposer.ts
│   └── AdvisoryFactory.ts
│
├── recommendation/
│   ├── RecommendationEngine.ts
│   └── ActionOptionBuilder.ts
│
├── justification/
│   ├── JustificationGenerator.ts
│   └── PolicyReferenceFormatter.ts
│
├── versioning/
│   └── AdvisoryVersionManager.ts
│
├── domain/
│   ├── Advisory.ts
│   └── RecommendationOption.ts
│
└── interfaces/
    └── IAdvisoryService.ts
```

#### Rules:

- **Cannot import decision-governance**
- **Cannot write to ledger**
- **Advisory immutable after creation**

---

## 4. Decision Governance Service

### This is the most sensitive.

```
decision-governance/
decision-governance/
│
├── authority/
│   ├── AuthorityValidator.ts
│   └── RolePolicyChecker.ts
│
├── recording/
│   ├── DecisionRecorder.ts
│   └── DecisionFactory.ts
│
├── state/
│   ├── DecisionStateMachine.ts
│   └── TransitionValidator.ts
│
├── escalation/
│   ├── EscalationManager.ts
│   └── EscalationPolicy.ts
│
├── ledger/
│   └── LedgerCommitAdapter.ts
│
├── domain/
│   ├── Decision.ts
│   ├── DecisionType.ts
│   └── DecisionStatus.ts
│
└── interfaces/
    └── IDecisionService.ts
```

#### Rules:

- **Only LedgerCommitAdapter can talk to ledger container**
- **StateMachine enforces invariant transitions**
- **No component can bypass AuthorityValidator**

---

## 5. Immutable Ledger

```
immutable-ledger/
immutable-ledger/
│
├── writer/
│   ├── AppendOnlyWriter.ts
│   └── LedgerEntryFactory.ts
│
├── hashing/
│   ├── HashChainGenerator.ts
│   └── IntegrityValidator.ts
│
├── indexing/
│   ├── TraceIndexer.ts
│   └── QueryEngine.ts
│
├── domain/
│   ├── LedgerEntry.ts
│   └── HashPointer.ts
│
└── interfaces/
    └── ILedgerService.ts
```

#### Rules:

- **No update operations exist**
- **Domain objects immutable**
- **HashChainGenerator cannot be bypassed**

---

## 6. Execution Bridge

```
execution-bridge/
execution-bridge/
│
├── translation/
│   └── ExecutionTranslator.ts
│
├── dispatch/
│   ├── Dispatcher.ts
│   └── TargetSystemAdapter.ts
│
├── acknowledgment/
│   └── ExecutionListener.ts
│
├── domain/
│   └── Execution.ts
│
└── interfaces/
    └── IExecutionService.ts
```

#### Rules:

- **Cannot execute without DecisionID**
- **Must log result via governance**

---

## 7. Administrative UI

```
admin-surface/
admin-surface/
│
├── pages/
│   ├── DashboardPage.tsx
│   ├── AdvisoryDetailPage.tsx
│   └── TraceReplayPage.tsx
│
├── components/
│   ├── RiskIndicator.tsx
│   ├── DecisionPanel.tsx
│   └── TraceTimeline.tsx
│
├── services/
│   └── GovernanceApiClient.ts
│
└── state/
    └── AdvisoryStateStore.ts
```

#### Rules:

- **No business logic in UI**
- **API client only talks to backend services**
- **No direct ledger access**

- **Strict multi repository separation**
or
- **Single repository with enforced module boundaries via build rules**

**We will define logical isolation independent of deployment.**

---

## Top Level Structural Layout

```
sentinelops/
│
├── ingestion/
├── policy-engine/
├── risk-engine/
├── advisory-engine/
├── decision-governance/
├── immutable-ledger/
├── execution-bridge/
├── admin-surface/
│
└── shared-contracts/
```

**Important rule:**

**shared-contracts contains only interface definitions, not implementations.**

---

## Container Internal Structures

Now we define internal module structure per container.

### 1. ingestion/

```
ingestion/
├── receiver/
├── validation/
├── normalization/
├── routing/
└── interfaces/
```

**Rules:**

- **Cannot import from policy-engine**
- **Cannot import from decision-governance**
- **Can only publish NormalizedEvent via shared-contracts**

### 2. policy-engine/

```
policy-engine/
├── repository/
├── interpreter/
├── evaluation/
├── conflict-resolution/
├── regulatory-mapping/
└── interfaces/
```

**Rules:**

- **Cannot import from ledger**
- **Cannot import from decision-governance**
- **Exposes PolicyEvaluationResult only via interfaces**

### 3. risk-engine/

```
risk-engine/
├── model-management/
├── calculation/
├── classification/
└── interfaces/
```

**Rules:**

- **Cannot import from advisory-engine**
- **Cannot import from ledger**
- **Only receives Event and PolicyContext**

### 4. advisory-engine/

```
advisory-engine/
├── composition/
├── justification/
├── recommendation/
├── versioning/
└── interfaces/
```

**Rules:**

- **Cannot import from decision-governance internals**
- **Cannot write to ledger**
- **Produces AdvisoryObject only**

### 5. decision-governance/

```
decision-governance/
├── authority-validation/
├── escalation/
├── state-control/
├── decision-recording/
├── ledger-adapter/
└── interfaces/
```

**Rules:**

- **Only container allowed to write to ledger**
- **Cannot evaluate policy**
- **Cannot calculate risk**
- **Cannot alter advisory content**

### 6. immutable-ledger/

```
immutable-ledger/
├── append-only-writer/
├── hash-chain/
├── verification/
├── trace-index/
└── interfaces/
```

**Rules:**

- **No update operations exist**
- **No delete operations exist**
- **Only accepts AppendEntry command**
- **Cannot depend on advisory or policy internals**

### 7. execution-bridge/

```
execution-bridge/
├── translation/
├── dispatch/
├── acknowledgment/
└── interfaces/
```

**Rules:**

- **Cannot execute without RecordedDecision**
- **Cannot bypass decision-governance**

### 8. admin-surface/

```
admin-surface/
├── advisory-view/
├── justification-render/
├── risk-display/
├── decision-capture/
└── trace-view/
```

**Rules:**

- **Cannot calculate risk**
- **Cannot evaluate policy**
- **Cannot write to ledger directly**
- **Only communicates via APIs**

---

## Dependency Direction Rules

### Allowed Directional Flow

```
Ingestion → Policy → Risk → Advisory → Decision Governance → Ledger
Decision Governance → Execution Bridge
Admin Surface ↔ Decision Governance
```

### Forbidden Directions

```
Policy → Ledger
Risk → Ledger
Advisory → Ledger
UI → Ledger
Execution → Ledger without governance
```

**No upward dependency.**
**No circular dependency.**

---

## Namespace Isolation Rules

### Container Namespace Structure

```
com.sentinelops.ingestion.*
com.sentinelops.policy.*
com.sentinelops.risk.*
com.sentinelops.advisory.*
com.sentinelops.governance.*
com.sentinelops.ledger.*
com.sentinelops.execution.*
com.sentinelops.admin.*
com.sentinelops.contracts.*
```

### Forbidden Import Patterns

```java
// FORBIDDEN: Direct internal module imports
import com.sentinelops.policy.repository.*;
import com.sentinelops.governance.authority.*;
import com.sentinelops.ledger.appendonly.*;

// ALLOWED: Interface only imports
import com.sentinelops.contracts.NormalizedEvent;
import com.sentinelops.contracts.PolicyEvaluationResult;
import com.sentinelops.contracts.AdvisoryObject;
```

---

## Enforcement Mechanisms

### At Build Time

- **Static dependency scanning**
- **Layered architecture rule enforcement**
- **Interface only imports across containers**

#### Build Rule Examples

```xml
<!-- Maven Enforcer Rule -->
<rules>
  <banDependencies>
    <excludes>
      <exclude>com.sentinelops.policy:*:*:*</exclude>
      <exclude>com.sentinelops.ledger:*:*:*</exclude>
    </excludes>
    <includes>
      <include>com.sentinelops.contracts:*:*:*</include>
    </includes>
  </banDependencies>
</rules>
```

```python
# Python Build Constraint
def check_dependencies():
    forbidden_imports = [
        'sentinelops.policy.repository',
        'sentinelops.governance.authority',
        'sentinelops.ledger.appendonly'
    ]
    
    allowed_imports = [
        'sentinelops.contracts'
    ]
    
    return validate_imports(forbidden_imports, allowed_imports)
```

### At Runtime

- **Separate service boundaries**
- **Role based access control**
- **Network level container isolation**

#### Service Boundary Configuration

```yaml
# Kubernetes Network Policy Example
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: sentinelops-boundaries
spec:
  podSelector:
    matchLabels:
      app: sentinelops
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          container: ingestion
    ports:
    - protocol: TCP
      port: 8080
  egress:
  - to:
    - podSelector:
        matchLabels:
          container: policy-engine
    ports:
    - protocol: TCP
      port: 8081
```

### At Governance Level

- **Ledger append only guarantees**
- **Authority validation before state transition**

#### Ledger Access Control

```java
// Ledger Interface - Append Only
public interface ImmutableLedger {
    LedgerEntry append(DecisionRecord decision);
    LedgerEntry append(ExecutionRecord execution);
    
    // NO UPDATE METHODS
    // NO DELETE METHODS
    
    Optional<LedgerEntry> get(String entryId);
    List<LedgerEntry> getTrace(String eventId);
    boolean verifyIntegrity();
}
```

---

## Module Responsibility Matrix

| Container | Primary Responsibility | Forbidden Dependencies | Allowed Dependencies |
|-----------|----------------------|----------------------|---------------------|
| **ingestion** | Signal normalization | policy, governance, ledger | contracts |
| **policy-engine** | Policy evaluation | ledger, governance | contracts, ingestion |
| **risk-engine** | Risk assessment | advisory, ledger | contracts, ingestion |
| **advisory-engine** | Recommendation synthesis | governance, ledger | contracts |
| **decision-governance** | Authority validation | policy, risk | contracts |
| **immutable-ledger** | Immutable storage | All internal modules | contracts |
| **execution-bridge** | Action execution | All except governance | contracts |
| **admin-surface** | User interface | All internal logic | contracts |

---

## Structural Boundary Violation Detection

### Automated Boundary Checking

```python
class BoundaryValidator:
    def validate_structure(self, project_path):
        violations = []
        
        # Check forbidden imports
        violations.extend(self.check_forbidden_imports(project_path))
        
        # Check dependency directions
        violations.extend(self.check_dependency_directions(project_path))
        
        # Check interface violations
        violations.extend(self.check_interface_violations(project_path))
        
        return violations
    
    def check_forbidden_imports(self, path):
        # Scan source files for forbidden import patterns
        pass
    
    def check_dependency_directions(self, path):
        # Validate module dependency graph
        pass
    
    def check_interface_violations(self, path):
        # Ensure cross-container communication uses interfaces only
        pass
```

### Continuous Integration Enforcement

```yaml
# GitHub Actions Example
name: Structural Boundary Check
on: [push, pull_request]

jobs:
  boundary-validation:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Validate Structural Boundaries
        run: |
          python scripts/validate_boundaries.py
          mvn enforcer:enforce
          npm run lint:architecture
```

---

## Deployment Structural Enforcement

### Container Isolation Strategy

```dockerfile
# Each container runs in isolated environment
FROM openjdk:11-jre-slim

# Copy only specific container modules
COPY ingestion/ /app/ingestion/
COPY shared-contracts/ /app/contracts/

# Network isolation
EXPOSE 8080

# Run as specific user
USER sentinelops

# Health check for boundary validation
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/health/boundaries || exit 1
```

### Service Mesh Integration

```yaml
# Istio Service Mesh Rules
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: sentinelops-boundaries
spec:
  selector:
    matchLabels:
      app: sentinelops
  rules:
  - from:
    - source:
        principals: ["cluster.local/ns/default/sa/ingestion-sa"]
  - to:
    - operation:
        methods: ["POST"]
        paths: ["/api/v1/events"]
```

---

## What Phase 5 Guarantees

- **No accidental cross container import**
- **No silent data mutation across domains**
- **No authority bypass via internal calls**
- **No UI driven logic injection**
- **No policy to ledger coupling**

**Structure now protects behavior.**

---

## Boundary Validation Criteria

The internal structure is valid if:

- **All cross-container imports use shared-contracts only**
- **Dependency graph follows allowed directional flow**
- **No circular dependencies exist**
- **Ledger access is limited to Decision Governance**
- **Build rules enforce structural boundaries**
- **Runtime isolation prevents boundary violations**
- **Automated validation catches violations early**

---

## Next Phase Preparation

This internal structure establishes the foundation for:

- **Phase 6:** Data domain identification respecting module boundaries
- **Phase 7-14:** Implementation that cannot violate structural rules
- **Team development** with enforced architectural compliance
- **Code reviews** focused on business logic, not boundary enforcement

---

## Internal Structure Summary

**This C4 Level 4 internal structure establishes enforceable architectural boundaries through namespace isolation, dependency direction control, and build-time validation, ensuring that the governance structure of SentinelOps cannot be violated through implementation choices.**

---

*This Phase 5 internal structure defines the enforceable boundaries that make SentinelOps governance structurally protected rather than conventionally dependent, ensuring that architectural guarantees survive implementation and evolution.*
