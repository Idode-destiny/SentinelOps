# Phase 2: Container Architecture


![Container Architecture](images/container_architecture.png)
## C4 Level 2: SentinelOps as Centralized Compliance Backbone

---

## Architectural Intent

Each container must have:

- **A single responsibility**
- **Clear authority limits**
- **No silent coupling**
- **Explicit communication contracts**
- **No cross domain data ownership**

**Observation must not mix with advisory.**
**Advisory must not mix with recording.**
**Recording must not mix with policy authorship.**

**Separation is governance protection.**

---

## Core Containers

### 1. Event Ingestion Layer

#### Responsibility

- **Receives signals from enterprise systems**
- **Normalizes events into canonical format**
- **Validates integrity**
- **Tags event source and domain**

#### Does Not

- **Evaluate compliance**
- **Assign risk**
- **Generate advisory**

#### Outcome

**Pure observation boundary.**

---

### 2. Policy & Regulatory Engine

#### Responsibility

- **Stores policies**
- **Maps policies to regulatory frameworks**
- **Interprets policy conditions**
- **Resolves conflicts**

#### Does Not

- **Execute actions**
- **Generate final advisory messaging**

#### Outcome

**Single source of compliance truth.**

---

### 3. Risk Scoring Engine

#### Responsibility

- **Calculates risk score per event**
- **Applies thresholds**
- **Classifies severity**

#### Does Not

- **Decide outcomes**
- **Record decisions**

#### Outcome

**Objective risk layer separated from compliance interpretation.**

---

### 4. Advisory Engine

#### Responsibility

- **Combines policy evaluation + risk output**
- **Produces recommendation**
- **Generates justification**
- **Attaches compliance references**

#### Does Not

- **Execute**
- **Override human authority**

#### Outcome

**Explainable recommendation layer.**

---

### 5. Decision Governance Service

#### Responsibility

- **Accepts administrator decision**
- **Validates authority role**
- **Records explicit decision**
- **Associates decision with advisory**

#### Does Not

- **Mutate ledger entries**
- **Modify advisory**

#### Outcome

**Human authority gate.**

---

### 6. Immutable Audit Ledger

#### Responsibility

- **Store full decision chain**
- **Enforce immutability**
- **Maintain hash chain integrity**
- **Provide replay capability**

#### Does Not

- **Interpret policy**
- **Generate advisory**
- **Allow mutation**

#### Outcome

**Governance backbone memory.**

---

### 7. Execution Bridge

#### Responsibility

- **Sends approved actions back to operational systems**
- **Logs execution acknowledgment**

#### Does Not

- **Decide independently**
- **Modify advisory logic**

#### Outcome

**Separation of governance from enforcement.**

---

### 8. Administrative Decision Surface

#### Responsibility

- **Present advisory**
- **Present justification**
- **Show risk classification**
- **Capture explicit decision**
- **Display trace**

#### Does Not

- **Evaluate compliance**
- **Directly modify ledger**

#### Outcome

**UI as decision surface, not control plane.**

---

## Communication Rules

### Strict Communication Pathways

```
Operational Systems → Event Ingestion
Event Ingestion → Policy Engine + Risk Engine
Policy + Risk → Advisory Engine
Advisory → Decision Governance
Decision Governance → Ledger
Decision Governance → Execution Bridge
Execution Result → Ledger
```

### Critical Constraints

- **Ledger is write only from Governance Service.**
- **No other container can write directly.**
- **No container can bypass Governance Service.**

---

## Container Relationship Visualization

![Container Architecture](images/container_architecture_view.png)

**This represents structural separation of reasoning, authority, and immutability.**

---

## Container Interaction Matrix

| Source Container | Target Container | Data Type | Authority Level |
|------------------|------------------|-----------|-----------------|
| **Event Ingestion** | Policy Engine | Normalized Events | Read |
| **Event Ingestion** | Risk Engine | Normalized Events | Read |
| **Policy Engine** | Advisory Engine | Policy Evaluations | Read |
| **Risk Engine** | Advisory Engine | Risk Scores | Read |
| **Advisory Engine** | Decision Governance | Recommendations | Read |
| **Decision Governance** | Ledger | Decision Records | Write |
| **Decision Governance** | Execution Bridge | Approved Actions | Write |
| **Execution Bridge** | Ledger | Execution Results | Write |
| **Admin Surface** | Decision Governance | Human Decisions | Write |

---

## Container Responsibility Map

### Data Ownership Boundaries

| Container | Owns Data | Reads Data | Writes Data | Authority |
|-----------|-----------|------------|-------------|-----------|
| **Event Ingestion** | Canonical Events | System Signals | Normalized Events | Observation |
| **Policy Engine** | Policy Rules | Events | Policy Results | Interpretation |
| **Risk Engine** | Risk Models | Events | Risk Scores | Assessment |
| **Advisory Engine** | Recommendations | Policy + Risk | Advisories | Advisory |
| **Decision Governance** | Decisions | Advisories | Decision Records | Authority |
| **Audit Ledger** | Decision History | Decision Records | Immutable Records | Memory |
| **Execution Bridge** | Execution Status | Approved Actions | Execution Logs | Enforcement |
| **Admin Surface** | UI State | Advisories | Decisions | Interface |

---

## Communication Contracts

### Event Ingestion → Policy Engine
**Contract:**
```json
{
  "eventId": "uuid",
  "timestamp": "iso8601",
  "source": "system_identifier",
  "domain": "domain_type",
  "eventType": "event_classification",
  "payload": "canonical_event_data",
  "integrityHash": "sha256"
}
```

### Policy Engine → Advisory Engine
**Contract:**
```json
{
  "eventId": "uuid",
  "policyEvaluations": [
    {
      "policyId": "policy_ref",
      "framework": "regulatory_framework",
      "result": "compliant|non_compliant|conditional",
      "conditions": "evaluation_details",
      "confidence": "numeric_score"
    }
  ],
  "conflictResolution": "resolution_method"
}
```

### Risk Engine → Advisory Engine
**Contract:**
```json
{
  "eventId": "uuid",
  "riskScore": "numeric_value",
  "severity": "low|medium|high|critical",
  "thresholds": "applied_criteria",
  "factors": "risk_contributors"
}
```

### Advisory Engine → Decision Governance
**Contract:**
```json
{
  "eventId": "uuid",
  "recommendation": "action_guidance",
  "justification": "explanation",
  "policyReferences": ["policy_citations"],
  "riskClassification": "risk_level",
  "complianceStatus": "status",
  "alternatives": ["option_list"]
}
```

### Decision Governance → Ledger
**Contract:**
```json
{
  "decisionId": "uuid",
  "eventId": "uuid",
  "administratorId": "user_identifier",
  "decision": "approved|rejected|modified",
  "authority": "role_validation",
  "timestamp": "iso8601",
  "justification": "human_reasoning",
  "advisoryId": "reference",
  "previousHash": "chain_link"
}
```

---

## Architectural Guarantees from This Separation

### Evolution Isolation

- **Policy logic can evolve without altering ledger integrity**
- **Risk model changes do not affect decision history**
- **UI redesign cannot affect authority logic**
- **Execution cannot occur without recorded decision**
- **Ledger cannot be altered by advisory logic**

### Governance Protection

- **No container can bypass human authority**
- **No silent decision execution**
- **No retroactive ledger modification**
- **No cross-domain data ownership conflicts**
- **No hidden communication pathways**

---

## Deployment Architecture

### Container Deployment Patterns

#### Event Ingestion Layer
- **Horizontal scaling** for high-volume signal processing
- **Stateless design** for load distribution
- **Input validation** at edge

#### Policy & Regulatory Engine
- **Vertical scaling** for complex rule processing
- **Caching layer** for frequently accessed policies
- **Version control** for policy evolution

#### Risk Scoring Engine
- **Batch processing** capability
- **Model versioning** for risk algorithm updates
- **Threshold management** interface

#### Advisory Engine
- **Real-time processing** requirements
- **Justification generation** compute resources
- **Compliance reference** caching

#### Decision Governance Service
- **High availability** deployment
- **Authority validation** security
- **Decision recording** persistence

#### Immutable Audit Ledger
- **Distributed storage** for resilience
- **Hash chain** verification
- **Read replicas** for audit queries

#### Execution Bridge
- **Secure communication** with operational systems
- **Execution logging** persistence
- **Acknowledgment** tracking

#### Administrative Decision Surface
- **Web application** deployment
- **Session management** security
- **Responsive design** for device access

---

## Security Boundaries

### Container Security Zones

| Security Zone | Containers | Access Level | Threat Model |
|----------------|------------|--------------|--------------|
| **Public Edge** | Event Ingestion | Input Only | Data Injection |
| **Internal Processing** | Policy, Risk, Advisory | Internal | Logic Tampering |
| **Authority Zone** | Decision Governance | Authenticated | Authority Bypass |
| **Immutable Storage** | Audit Ledger | Write-Once | Data Corruption |
| **Execution Zone** | Execution Bridge | Authenticated | Unauthorized Action |
| **User Interface** | Admin Surface | Authenticated | UI Manipulation |

---

## Strategic Positioning

### Enterprise-Level Demonstrations

This architecture demonstrates:

- **Separation of advisory from enforcement**
- **Immutable decision memory**
- **Human authority preservation**
- **Regulatory defensibility**
- **Containerized compliance reasoning**

### Institutional Grade Structure

**This is structural governance, not convention based governance.**

---

## Container Validation Criteria

The container architecture is valid if:

- **Each container has exactly one responsibility**
- **No container can bypass Decision Governance**
- **Only Decision Governance can write to the Ledger**
- **All communication follows explicit contracts**
- **No cross-domain data ownership exists**
- **Human authority is preserved in all paths**
- **Immutability is enforced at the architectural level**

---

## Next Phase Preparation

This container architecture establishes the foundation for:

- **Phase 3:** Authority and behavioral modeling within container boundaries
- **Phase 4:** Component decomposition inside containers
- **Phase 5-14:** Detailed implementation respecting container contracts

---

*This C4 Level 2 container architecture establishes structural governance through enforced separation of concerns, ensuring that observation, reasoning, authority, and immutability remain architecturally distinct.*
